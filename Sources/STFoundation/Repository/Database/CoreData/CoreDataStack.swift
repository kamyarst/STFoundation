// swiftlint:disable all
//  CoreDataStack.swift
//
//
//  Created by Kamyar on 27/01/2023.
//

import CloudKit
import CoreData
import Foundation

// MARK: - CoreDataStack

public final class CoreDataStack {

    private(set) var configs: CoreDataConfigurationProtocol
    public lazy var persistentContainer = createContainer()

    public var hasCloudKit: Bool { FileManager.default.ubiquityIdentityToken != nil }

    private var iCloudAvailable: Bool { self.hasCloudKit && self.configs.iCloud }

    public lazy var mainQueueContext: NSManagedObjectContext = self.persistentContainer.viewContext

    public var privateQueueContext: NSManagedObjectContext {
        let context = self.persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
    }

    public lazy var privateStoreDescription: NSPersistentStoreDescription = {
        let privateStoreURL = URL.storeURL(for: self.configs.appGroupBundle,
                                           databaseName: self.configs.containerName)
        let privateDescription = NSPersistentStoreDescription(url: privateStoreURL)

        if self.configs.iCloud {
            privateDescription
                .cloudKitContainerOptions =
                NSPersistentCloudKitContainerOptions(containerIdentifier: self.configs.cloudKitBundle)
        } else {
            privateDescription.cloudKitContainerOptions = nil
        }

        privateDescription.setOption(true as NSNumber,
                                     forKey: NSPersistentHistoryTrackingKey)
        privateDescription.setOption(true as NSNumber,
                                     forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

        return privateDescription
    }()

    public lazy var sharedStoreDescription: NSPersistentStoreDescription = {
        let sharedStoreURL = URL.storeURL(for: self.configs.appGroupBundle,
                                          databaseName: self.configs.containerName + ".shared")
        guard let sharedDescription = self.privateStoreDescription.copy() as? NSPersistentStoreDescription
        else { fatalError() }
        sharedDescription.url = sharedStoreURL
        let sharedStoreOptions =
            NSPersistentCloudKitContainerOptions(containerIdentifier: self.configs.cloudKitBundle)
        sharedStoreOptions.databaseScope = .shared
        sharedDescription.cloudKitContainerOptions = sharedStoreOptions
        return sharedDescription
    }()

    public var sharedStore: NSPersistentStore? {
        let sharedStoreURL = URL.storeURL(for: self.configs.appGroupBundle,
                                          databaseName: self.configs.containerName + ".shared")
        return self.persistentContainer.persistentStoreCoordinator.persistentStore(for: sharedStoreURL)
    }

    // MARK: - Core Data stack

    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        let coreBundle = Bundle(for: CoreDataStack.self)
        guard let modelURL = coreBundle.url(forResource: self.configs.containerName,
                                            withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: modelURL)
        else { fatalError() }
        return model
    }()

    public init(_ configs: CoreDataConfigurationProtocol) {
        self.configs = configs
    }

    public func reInitiateContainer() {
        var option = self.persistentContainer.persistentStoreDescriptions.first?.cloudKitContainerOptions
        if self.iCloudAvailable {
            option = NSPersistentCloudKitContainerOptions(containerIdentifier: self.configs.cloudKitBundle)
        } else {
            option = nil
        }
        self.persistentContainer.persistentStoreDescriptions.first?.cloudKitContainerOptions = option
    }

    public func hasRemoteData() async -> Bool? {
        let db = CKContainer.default().privateCloudDatabase
        let predicate = NSPredicate(format: "CD_entityName = 'User'")
        let query = CKQuery(recordType: .init("CD_User"), predicate: predicate)
        do {
            let records = try await db.perform(query, inZoneWith: nil)
            return records.isEmpty ? nil : true
        } catch {
            log(.error, "Failed to get remote data", error.localizedDescription)
            return false
        }
    }

    public func deleteCloudKit() async throws {
        let container = CKContainer(identifier: self.configs.cloudKitBundle)
        let database = container.privateCloudDatabase

        let zones = try await database.allRecordZones()
        for zone in zones {
            try await database.deleteRecordZone(withID: zone.zoneID)
            log(.info, "CloudKit Zone with id \(zone.zoneID) is removed")
        }
        log(.info, "Remove CloudKit", "CloudKit successfully removed")

//        let zone = CKRecordZone.ID(zoneName: "com.apple.coredata.cloudkit.zone")
//        do {
//            try await database.deleteRecordZone(withID: zone)
//        } catch {
//            log(.error, "Remove CloudKit", error.localizedDescription)
//        }
    }

    public func deleteCoreData() async throws {
        let entityNames = self.persistentContainer.managedObjectModel.entities.compactMap { $0.name }
        entityNames.forEach { [weak self] entityName in
            guard let self else { return }
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

            do {
                try self.mainQueueContext.execute(deleteRequest)
                try self.mainQueueContext.save()
            } catch {
                log(.error, "Remove CoreData", error.localizedDescription)
            }
        }
    }

    private func createContainer() -> NSPersistentContainer {
        let container = NSPersistentCloudKitContainer(name: configs.containerName,
                                                      managedObjectModel: self.managedObjectModel)

        container.persistentStoreDescriptions = [self.privateStoreDescription, self.sharedStoreDescription]

        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy

        return container
    }
}

extension CoreDataStack {
    private func isShared(objectID: NSManagedObjectID) -> Bool {
        var isShared = false
        if let persistentStore = objectID.persistentStore {
            if persistentStore == self.sharedStore {
                isShared = true
            } else {
                let container = self.persistentContainer
                do {
                    let shares = try (container as? NSPersistentCloudKitContainer)?
                        .fetchShares(matching: [objectID])

                    if shares?.first != nil {
                        isShared = true
                    }
                } catch {
                    print("Failed to fetch share for \(objectID): \(error)")
                }
            }
        }
        return isShared
    }

    func isOwner(object: NSManagedObject) -> Bool {
        guard self.isShared(objectID: object.objectID) else { return false }
        let container = self.persistentContainer
        guard let share = try? (container as? NSPersistentCloudKitContainer)?
            .fetchShares(matching: [object.objectID])[object.objectID] else {
            print("Get ckshare error")
            return false
        }
        if let currentUser = share.currentUserParticipant, currentUser == share.owner {
            return true
        }
        return false
    }
}
