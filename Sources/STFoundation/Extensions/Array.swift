//
//  Array.swift
//
//
//  Created by Kamyar on 28/01/2023.
//

import Foundation

public extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }

    subscript(safe bounds: ClosedRange<Int>) -> [Element] {
        guard bounds.lowerBound >= 0 else {
            return []
        }
        let upperBand = Swift.min(bounds.upperBound, self.count - 1)
        return Array(self[bounds.lowerBound ... upperBand])
    }
}

public extension Array where Element: Hashable {
    var set: Set<Element> {
        Set(self)
    }
}

public extension Array where Element: Equatable {

    func removingDuplicates() -> [Element] {
        var result = [Element]()
        for element in self {
            if !result.contains(element) {
                result.append(element)
            }
        }
        return result
    }

    mutating func set(_ element: Element) {
        var temp = self
        temp.append(element)
        self = NSOrderedSet(array: temp).array.compactMap { $0 as? Element }
    }
}
