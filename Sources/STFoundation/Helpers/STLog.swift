//
//  STLog.swift
//
//
//  Created by Kamyar on 27/01/2023.
//

import OSLog

public func STLog(_ level: OSLogType,
                  _ function: String = #function,
                  _ title: String,
                  _ description: String...) {

    if #available(watchOS 7.0, *) {
        let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "JointBudget")
        logger
            .info("\n===== \(level.emoji) \(title) \(level.emoji) ===== \n\(function, privacy: .private)\n\(description.joined(separator: "\n"), privacy: .private)\n==============================================\n")
    } else {
        print("\n===== \(level.emoji) \(title) \(level.emoji) ===== \n\(function)\n\(description.joined(separator: "\n"))\n==============================================\n")
    }
}

extension OSLogType {
    var emoji: String {
        switch self {
        case .info: return "🟢"
        case .error: return"🔴"
        case .debug: return"🟡"
        case .fault: return"🟠"
        case .default: return "🟢"
        default: return ""
        }
    }
}
