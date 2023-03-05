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
        let sharedDescription = privateStoreDescription.copy() as! NSPersistentStoreDescription
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
       return persistentContainer.persistentStoreCoordinator.persistentStore(for: sharedStoreURL)
        
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

        let container = CKContainer(identifier: self.configs.cloudKitBundle)
        let database = container.privateCloudDatabase
        database.delete(withRecordZoneID: .init(zoneName: "com.apple.coredata.cloudkit.zone"),
                        completionHandler: { _, error in
                            if let error {
                                log(.error, "Remove CloudKit", error.localizedDescription)
                            }
                            log(.info, "Remove CloudKit", "CloudKit successfully removed")
                            self.resetAllCoreData()
                            completion()
                        })
    }

    public func resetAllCoreData() {

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

        container.persistentStoreDescriptions = [privateStoreDescription, sharedStoreDescription]

        container.loadPersistentStores(completionHandler: { value, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy

        return container
    }
}

// import UIKit
//
// @UIApplicationMain
// class AppDelegate: UIResponder, UIApplicationDelegate {
//
//    func application(_ application: UIApplication, userDidAcceptCloudKitShareWith cloudKitShareMetadata:
//    CKShare.Metadata) {
//
//    }
// }
