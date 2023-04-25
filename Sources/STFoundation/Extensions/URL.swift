//
//  URL.swift
//
//
//  Created by Kamyar on 27/01/2023.
//

import Foundation

public extension URL {

    /// Returns a URL for the given app group and database pointing to the sqlite database.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: appGroup)
        else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }

    static func jsonURL(for appGroup: String, jsonName: String) -> URL {
        guard let fileContainer = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: appGroup)
        else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(jsonName).json")
    }
}
