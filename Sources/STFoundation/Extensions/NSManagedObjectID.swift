//
//  NSManagedObjectID.swift
//
//
//  Created by Kamyar on 28/01/2023.
//

import CoreData

public extension NSManagedObjectID {

    /// - Returns: Absolute String of URI Representation
    var string: String {
        self.uriRepresentation().absoluteString
    }
}
