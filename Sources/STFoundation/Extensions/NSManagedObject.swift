//
//  NSManagedObject.swift
//
//
//  Created by Kamyar Sehati on 19/03/2023.
//

import CoreData

public extension NSManagedObject {

    func prettyPrint() -> [String: Any] {
        let entity = self.entity
        let properties = entity.propertiesByName

        var dictionary: [String: Any] = [:]

        for (key, _) in properties {
            if let value = self.value(forKey: key) {
                dictionary[key] = value
            } else {
                dictionary[key] = nil
            }
        }

        return dictionary
    }
}
