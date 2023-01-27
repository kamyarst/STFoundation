//
//  CoreDataLoader.swift
//
//
//  Created by Kamyar on 27/01/2023.
//

import CoreData

final class CoreDataLoader: LoaderProtocol {

    typealias Entity = NSManagedObject
    typealias Query = NSPredicate

    private(set) var context: NSManagedObjectContext
    private(set) var fetchRequest: NSFetchRequest<Entity>

    init(context: NSManagedObjectContext, fetchRequest: NSFetchRequest<Entity>) {
        self.context = context
        self.fetchRequest = fetchRequest
    }

    func get(predicate: NSPredicate?) async throws -> Entity {

        self.fetchRequest.fetchLimit = 1
        guard let data = try await self.list(predicate: predicate).first else {
            STLog(.error, #function, "Core Data", CoreDataError.notExist.localizedDescription)
            self.fetchRequest.fetchLimit = .zero
            throw CoreDataError.operateFailed
        }
        self.fetchRequest.fetchLimit = .zero
        return data
    }

    func list(predicate: NSPredicate?) async throws -> [Entity] {

        do {
            self.fetchRequest.predicate = predicate
            let entities = try self.context.fetch(self.fetchRequest)
            STLog(.info, #function, "Core Data", "\(entities)")
            return entities
        } catch {
            STLog(.error, #function, "Core Data", error.localizedDescription)
            throw CoreDataError.operateFailed
        }
    }

    func insert(_ item: Entity) async throws {

        self.context.insert(item)
        do {
            try self.context.saveIfNeeded()
            STLog(.info, #function, "Core Data", "\(item)")
        } catch {
            STLog(.error, #function, "Core Data", error.localizedDescription)
            throw CoreDataError.operateFailed
        }
    }

    func update(_ item: Entity) async throws {

        do {
            try self.context.saveIfNeeded()
            STLog(.info, #function, "Core Data", "\(item)")
        } catch {
            STLog(.error, #function, "Core Data", error.localizedDescription)
            throw CoreDataError.operateFailed
        }
    }

    func delete(_ item: Entity) async throws {

        self.context.delete(item)
        do {
            try self.context.saveIfNeeded()
            STLog(.info, #function, "Core Data", "\(item)")
        } catch {
            STLog(.error, #function, "Core Data", error.localizedDescription)
            throw CoreDataError.operateFailed
        }
    }

    enum CoreDataError: Error {
        case operateFailed
        case notExist
    }
}
