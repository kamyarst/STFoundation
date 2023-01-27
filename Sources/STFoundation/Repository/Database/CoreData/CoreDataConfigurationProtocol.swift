//
//  CoreDataConfigurationProtocol.swift
//  
//
//  Created by Kamyar on 27/01/2023.
//

import Foundation

public protocol CoreDataConfigurationProtocol {
    var iCloud: Bool { get set }
    var containerName: String { get set }
    var appBundle: String { get set }
    var appGroupBundle: String { get set }
    var cloudKitBundle: String { get set }
}
