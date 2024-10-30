//
//  Asserts.swift
//  STFoundation
//
//  Created by Kamyar Sehati on 30/10/2024.
//

import Foundation

public func assertMainThread() {
    assert(Thread.current.isMainThread)
}

public func assertBackgroundThread() {
    assert(!Thread.current.isMainThread)
}
