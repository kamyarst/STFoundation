//
//  Asserts.swift
//  STFoundation
//
//  Created by Kamyar Sehati on 30/10/2024.
//

import Foundation

// MARK: - ThreadType

public enum ThreadType {
    case main
    case background
}

public func assertThread(_ type: ThreadType, file: StaticString = #file, line: UInt = #line) {
    if type == .main {
        assert(Thread.current.isMainThread, file: file, line: line)
    } else {
        assert(!Thread.current.isMainThread, file: file, line: line)
    }
}
