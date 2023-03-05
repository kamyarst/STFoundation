//
//  CoreDataLoader.swift
//
//
//  Created by Kamyar on 27/01/2023.
//

import CoreData

public final class CoreDataLoader<T: NSManagedObject>: LoaderProtocol {

    public typealias Entity = T
    public typealias Query = NSPredicate

    private(set) var context: NSManagedObjectContext
    private(set) var fetchRequest: NSFetchRequest<Entity>

    public init(context: NSManagedObjectContext, fetchRequest: NSFetchRequest<Entity>) {
        self.context = context
        self.fetchRequest = fetchRequest
    }

    public func get(predicate: NSPredicate?) async throws -> Entity {

        self.fetchRequest.fetchLimit = 1
        guard let data = try await self.list(predicate: predicate).first else {
            log(.error, "Core Data", CoreDataError.notExist.localizedDescription)
            self.fetchRequest.fetchLimit = .zero
            throw CoreDataError.operateFailed
        }
        self.fetchRequest.fetchLimit = .zero
        return data
    }

    public func list(predicate: NSPredicate?) async throws -> [Entity] {

        do {
            self.fetchRequest.predicate = predicate
            let entities = try self.context.fetch(self.fetchRequest)
            log(.info, "Core Data", "\(entities)")
            return entities
        } catch {
            log(.error, "Core Data", error.localizedDescription)
            throw CoreDataError.operateFailed
        }
    }

    public func insert(_ item: Entity) async throws {

        self.context.insert(item)
        do {
            try self.context.saveIfNeeded()
            log(.info, "Core Data", "\(item)")
        } catch {
            log(.error, "Core Data", error.localizedDescription)
            throw CoreDataError.operateFailed
        }
    }

    public func update(_ item: Entity) async throws {

        do {
            try self.context.saveIfNeeded()
            log(.info, "Core Data", "\(item)")
        } catch {
            log(.error, "Core Data", error.localizedDescription)
            throw CoreDataError.operateFailed
        }
    }

    public func delete(_ item: Entity) async throws {

        self.context.delete(item)
        do {
            try self.context.saveIfNeeded()
            log(.info, "Core Data", "\(item)")
        } catch {
            log(.error, "Core Data", error.localizedDescription)
            throw CoreDataError.operateFailed
        }
    }

    public func getEntity(URIRepresentation: URL?) throws -> Entity {
        guard let url = URIRepresentation,
              let objectId = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url),
              let modelCD = context.object(with: objectId) as? Entity
        else { throw CoreDataError.invalidObjectId }
        return modelCD
    }

    enum CoreDataError: Error {
        case operateFailed
        case notExist
        case invalidObjectId
    }
}
