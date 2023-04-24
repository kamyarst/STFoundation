//
//  log.swift
//
//
//  Created by Kamyar on 27/01/2023.
//

import Foundation

public func log(_ type: LogType, _ items: Any..., separator: String? = nil,
                file: String = #file, line: Int = #line, function: String = #function) {
    #if DEBUG
        LogManager().log(items,
                         emoji: type.emoji,
                         separator: separator ?? type.separator,
                         bullet: type.bullet,
                         file: file,
                         function: function,
                         line: line)
    #endif
}

// MARK: - LogManager

private struct LogManager {

    private var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "H:m:ss.SSS"
        return formatter
    }()

    func log(_ items: [Any], emoji: String, separator: String, bullet: String, file: String, function: String,
             line: Int) {
        let lastSlashIndex = (file.lastIndex(of: "/") ?? String.Index(utf16Offset: 0, in: file))
        let nextIndex = file.index(after: lastSlashIndex)
        let filename = file.suffix(from: nextIndex).replacingOccurrences(of: ".swift", with: "")

        let dateString = self.formatter.string(from: Date())

        let prefix = "\(emoji) [\(dateString)] \(filename).\(function):\(line)"

        let message = items.map { "\(bullet)\($0)" }.joined(separator: separator)
        print("\(prefix)\n\(message)\n")
    }
}

// MARK: - LogModel

public struct LogModel {
    var emoji: String
    var separator = "\n"
    var bullet = " → "
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
