//
//  NSManagedObjectContext.swift
//
//
//  Created by Kamyar on 27/01/2023.
//

import CoreData

extension NSManagedObjectContext {

    /// Only performs a save if there are changes to commit.
    /// - Returns: `true` if a save was needed. Otherwise, `false`.
    @discardableResult func saveIfNeeded() throws -> Bool {
        guard hasChanges else { return false }
        try save()
        return true
    }
}
