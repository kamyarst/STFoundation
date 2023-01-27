//
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

    private(set) var configurations: CoreDataConfigurationProtocol
    private(set) var persistentContainer: NSPersistentContainer

    public var hasCloudKit: Bool { FileManager.default.ubiquityIdentityToken != nil }

    private var iCloudAvailable: Bool { self.hasCloudKit && self.configurations.iCloud }

    public lazy var mainQueueContext: NSManagedObjectContext = self.persistentContainer.viewContext

    public var privateQueueContext: NSManagedObjectContext {
        let context = self.persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
    }

    // MARK: - Core Data stack

    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        let coreBundle = Bundle(for: CoreDataStack.self)
        guard let modelURL = coreBundle.url(forResource: self.configurations.containerName,
                                            withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: modelURL)
        else { fatalError() }
        return model
    }()

    private init(container: NSPersistentContainer,
                 _ config: CoreDataConfigurationProtocol) {
        self.configurations = config
        self.persistentContainer = container
    }

    public func reInitiateContainer() {

        var option = self.persistentContainer.persistentStoreDescriptions.first?.cloudKitContainerOptions
        if self.iCloudAvailable {
            option = NSPersistentCloudKitContainerOptions(containerIdentifier: self.configurations.cloudKitBundle)
        } else {
            option = nil
        }
        self.persistentContainer.persistentStoreDescriptions.first?.cloudKitContainerOptions = option
    }

    public func checkRemoteData(completion: @escaping (Bool?) -> Void) {

        let db = CKContainer.default().privateCloudDatabase
        let predicate = NSPredicate(format: "CD_entityName = 'User'")
        let query = CKQuery(recordType: .init("CD_User"), predicate: predicate)

        db.perform(query, inZoneWith: nil) { result, error in
            if error == nil {
                if let records = result, !records.isEmpty {
                    completion(true)
                } else {
                    completion(nil)
                }
            } else {
                print(error as Any)
                completion(false)
            }
        }
    }

    public func deleteCloudKit(_ completion: @escaping () -> Void) {

        let container = CKContainer(identifier: self.configurations.cloudKitBundle)
        let database = container.privateCloudDatabase
        database.delete(withRecordZoneID: .init(zoneName: "com.apple.coredata.cloudkit.zone"),
                        completionHandler: { _, error in
                            if let error {
                                STLog(.error, #function, "Remove CloudKit", error.localizedDescription)
                            }
                            STLog(.info, #function, "Remove CloudKit", "CloudKit successfully removed")
                            self.resetAllCoreData()
                            completion()
                        })
    }

    func resetAllCoreData() {

        let entityNames = self.persistentContainer.managedObjectModel.entities.compactMap { $0.name! }
        entityNames.forEach { [weak self] entityName in
            guard let self else { return }
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

            do {
                try self.mainQueueContext.execute(deleteRequest)
                try self.mainQueueContext.save()
            } catch {
                STLog(.error, #function, "Remove CoreData", error.localizedDescription)
            }
        }
    }
}

private func createContainer(for managesObjectModel: NSManagedObjectModel,
                             configs: CoreDataConfigurationProtocol) -> NSPersistentContainer {
    let container = NSPersistentCloudKitContainer(name: configs.containerName,
                                                  managedObjectModel: managesObjectModel)

    let storeURL = URL.storeURL(for: configs.appGroupBundle, databaseName: configs.containerName)
    let description = NSPersistentStoreDescription(url: storeURL)

    if configs.iCloud {
        description
            .cloudKitContainerOptions =
            NSPersistentCloudKitContainerOptions(containerIdentifier: configs.cloudKitBundle)
    } else {
        description.cloudKitContainerOptions = nil
    }

    description.setOption(true as NSNumber,
                          forKey: NSPersistentHistoryTrackingKey)

    description.setOption(true as NSNumber,
                          forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
    container.persistentStoreDescriptions = [description]

    container.loadPersistentStores(completionHandler: { _, error in
        if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    })

    container.viewContext.automaticallyMergesChangesFromParent = true
    container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy

    return container
}
