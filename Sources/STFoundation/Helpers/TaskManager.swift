//
//  TaskManager.swift
//
//
//  Created by Kamyar Sehati on 30/04/2024.
//

import Foundation

public actor TaskManager: Sendable {
    public static let shared = TaskManager()
    private var tasks: [UUID: Task<Void, Never>] = [:]

    public var inProgress: Bool {
        !self.tasks.isEmpty
    }

    private init() { }

    @discardableResult
    public func startTask(_ task: @escaping @Sendable () async throws -> Void, completion: (@Sendable () async -> Void)? = nil) -> UUID {
        let uuid = UUID()
        let taskInstance = Task.detached { [weak self] in
            do {
                log(.info, .logic, "Starting task with UUID: \(uuid)")
                try await task()
                // If the task completes, we remove it from our dictionary
            } catch {
                log(.error, .none, error)
            }
            await completion?()
            await self?.removeTask(uuid: uuid)
            log(.info, .logic, "Finished task with UUID: \(uuid)")
        }
        
        self.tasks[uuid] = taskInstance
        return uuid
    }
    
    private func removeTask(uuid: UUID) {
        self.tasks.removeValue(forKey: uuid)
    }

    public func cancelTask(with uuid: UUID) {
        self.tasks[uuid]?.cancel()
        self.tasks.removeValue(forKey: uuid)
    }
}
