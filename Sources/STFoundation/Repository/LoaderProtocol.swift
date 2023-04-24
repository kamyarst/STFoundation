//
//  LoaderProtocol.swift
//
//
//  Created by Kamyar on 27/01/2023.
//

import Foundation

protocol LoaderProtocol {
    associatedtype Entity
    associatedtype Query

    @discardableResult
    func get(predicate: Query?) async throws -> Entity
    @discardableResult
    func list(predicate: Query?) async throws -> [Entity]
    func insert(_ item: [Entity]) async throws
    func update(_ item: Entity) async throws
    func delete(_ item: Entity) async throws
}
