//
//  TaskManager.swift
//
//
//  Created by Kamyar Sehati on 30/04/2024.
//

import Foundation

public class TaskManager {
    public static let shared = TaskManager()
    private var tasks: [UUID: Task<Void, Never>] = [:]

    public var inProgress: Bool {
        !self.tasks.isEmpty
    }

    private init() { }

    @discardableResult
    public func startTask(_ task: @escaping () async throws -> Void) -> UUID {
        let uuid = UUID()
        self.tasks[uuid] = Task.detached {
            do {
                try await task()
                // If the task completes, we remove it from our dictionary
                self.tasks.removeValue(forKey: uuid)
            } catch {
                log(.error, .none, error)
                self.tasks.removeValue(forKey: uuid)
            }
        }
        return uuid
    }

    public func cancelTask(with uuid: UUID) {
        self.tasks[uuid]?.cancel()
        self.tasks.removeValue(forKey: uuid)
    }
}
