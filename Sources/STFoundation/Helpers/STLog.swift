//
//  STLog.swift
//
//
//  Created by Kamyar on 27/01/2023.
//

import Foundation
import OSLog

public func log(_ type: LogType, _ category: LogCategory, _ items: Any..., separator: String? = nil,
                file: String = #fileID, line: Int = #line, function: String = #function) {
    LogManager().log(items,
                     category: category,
                     type: type,
                     separator: separator ?? type.separator,
                     file: file,
                     function: function,
                     line: line)
}

// MARK: - LogManager

private struct LogManager {

    func log(_ items: [Any], category: LogCategory, type: LogType, separator: String, file: String, function: String,
             line: Int) {
        let lastSlashIndex = (file.lastIndex(of: "/") ?? String.Index(utf16Offset: 0, in: file))
        let nextIndex = file.index(after: lastSlashIndex)
        let filename = file.suffix(from: nextIndex).replacingOccurrences(of: ".swift", with: "")

        let prefix = "\(type.emoji) \(filename).\(function):\(line)"
        let logs = items.map { "\(type.bullet)\($0)" }.joined(separator: separator)
        let message = "\(prefix)\n\(logs)"

        let subsystem = Bundle.main.bundleIdentifier!
        let logger: Logger
        if let category = category.name {
            logger = Logger(subsystem: subsystem, category: category)
        } else {
            logger = Logger()
        }

        switch type {
        case .error:
            logger.fault("\(message, privacy: .private)")

        case .info:
            logger.notice("\(message, privacy: .private)")

        case .warning:
            logger.warning("\(message, privacy: .private)")

        case .debug:
            logger.debug("\(message, privacy: .private)")

        case .request, .response:
            logger.trace("\(message, privacy: .private)")

        case let .custom(logModel):
            logger.error("\(message, privacy: .private)")
        }
    }
}

// MARK: - LogCategory

public enum LogCategory {
    case network
    case database
    case logic
    case view
    case codable
    case none
    case custom(String)

    var name: String? {
        switch self {
        case .network: "Network"
        case .database: "Database"
        case .codable: "Codable"
        case .logic: "Logic"
        case .view: "View"
        case .none: nil
        case let .custom(string): string
        }
    }
}

// MARK: - LogModel

public struct LogModel {
    var emoji: String
    var separator = "\n"
    var bullet = " → "

    public init(emoji: String, separator: String = "\n", bullet: String = " → ") {
        self.emoji = emoji
        self.separator = separator
        self.bullet = bullet
    }
}

// MARK: - LogType

public enum LogType {
    case error
    case info
    case warning
    case debug
    case request
    case response
    case custom(LogModel)

    var emoji: String {
        switch self {
        case .error: return "🔥"
        case .info: return "✅"
        case .warning: return "⚠️"
        case .debug: return "📀"
        case .request: return "🚀"
        case .response: return "🌍"
        case let .custom(model): return model.emoji
        }
    }

    var separator: String {
        switch self {
        case .error, .info, .warning, .debug, .request, .response:
            return "\n"
        case let .custom(model):
            return model.separator
        }
    }

    var bullet: String {
        switch self {
        case .error, .info, .warning, .debug:
            return " → "
        case .request, .response:
            return " ⦿ "
        case let .custom(model): return model.bullet
        }
    }
}
