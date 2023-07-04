//
//  Array.swift
//
//
//  Created by Kamyar on 28/01/2023.
//

import Foundation

public extension Array where Element: Hashable {
    var set: Set<Element> {
        Set(self)
    }
}
