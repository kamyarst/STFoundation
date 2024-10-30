//
//  Sequence+extension.swift
//
//
//  Created by Kamyar Sehati on 02/07/2023.
//

import Foundation

public extension Sequence {
    func asyncCompactMap<T>(_ transform: @escaping (Element) async throws -> T?) async rethrows -> [T] {
        await withTaskGroup(of: (Element, T?).self,
                            returning: [T].self) { group in
            for element in self {
                group.addTask {
                    let result = try? await transform(element)
                    return (element, result)
                }
            }
            var transformedResults = [T]()
            for await(_, result) in group {
                if let result {
                    transformedResults.append(result)
                }
            }
            return transformedResults
        }
    }
}
