//
//  DateExtensionTests.swift
//  STFoundation
//
//  Created by Kamyar Sehati on 19/09/2024.
//

import Foundation
@testable import STFoundation
import Testing

// MARK: - DateExtensionTests

struct DateExtensionTests {

    private static var mockDate = Date("2024-09-19")!

    @Test("Remove time",
          arguments: [(mockDate, mockDate.addingTimeInterval(100)),
                      (mockDate.addDay(1), mockDate.addingTimeInterval(86400))])
    func getDateOnly(dates: (Date, Date)) async throws {
        #expect(dates.0 == dates.1.dateOnly)
    }

    @Test("Add x days to a date",
          arguments: [MockModel(toAdd: 0, original: Date(), expected: Date()),
                      MockModel(toAdd: 1, expected: Date("2024-09-20")!),
                      MockModel(toAdd: 100, expected: Date("2024-12-28")!),
                      MockModel(toAdd: 200, expected: Date("2025-04-07")!),
                      MockModel(toAdd: 365, expected: Date("2025-09-19")!)])
    func addDay(mock: MockModel) async throws {
        let date = mock.original
        let expected = mock.expected
        #expect(date.addDay(mock.toAdd) == expected)
    }

    @Test("Add x weeks to a date",
          arguments: [MockModel(toAdd: 0, original: Date(), expected: Date()),
                      MockModel(toAdd: 1, expected: Date("2024-09-26")!),
                      MockModel(toAdd: 100, expected: Date("2026-08-20")!),
                      MockModel(toAdd: 200, expected: Date("2028-07-20")!)])
    func addWeek(mock: MockModel) async throws {
        let date = mock.original
        let expected = mock.expected
        #expect(date.addWeek(mock.toAdd) == expected)
    }

    @Test("Add x months to a date",
          arguments: [MockModel(toAdd: 0, original: Date(), expected: Date()),
                      MockModel(toAdd: 1, expected: Date("2024-10-19")!),
                      MockModel(toAdd: 100, expected: Date("2033-01-19")!),
                      MockModel(toAdd: -1, expected: Date("2024-08-19")!)])
    func addMonth(mock: MockModel) async throws {
        let date = mock.original
        let expected = mock.expected
        #expect(date.addMonth(mock.toAdd) == expected)
    }

    @Test("get first day of month",
          arguments: [MockModel(original: mockDate, expected: Date("2024-09-01")!),
                      MockModel(original: Date("2024-09-01")!, expected: Date("2024-09-01")!),
                      MockModel(original: Date("2024-09-30")!,
                                expected: Date("2024-09-01")!)])
    func getFirstDayOfMonth(mock: MockModel) async throws {
        #expect(mock.original.firstDateOfMonth == mock.expected)
    }

    @Test("get last day of month",
          arguments: [MockModel(original: mockDate, expected: Date("2024-09-30")!),
                      MockModel(original: Date("2024-09-30")!, expected: Date("2024-09-30")!),
                      MockModel(original: Date("2024-09-01")!, expected: Date("2024-09-30")!),
                      MockModel(original: Date("2024-01-01")!, expected: Date("2024-01-31")!),
                      MockModel(original: Date("2024-01-31")!, expected: Date("2024-01-31")!),
                      MockModel(original: Date("2024-01-19")!, expected: Date("2024-01-31")!),
                      MockModel(original: Date("2024-02-01")!, expected: Date("2024-02-29")!),
                      MockModel(original: Date("2024-02-29")!, expected: Date("2024-02-29")!),
                      MockModel(original: Date("2024-02-19")!, expected: Date("2024-02-29")!)])
    func getLastDayOfMonth(mock: MockModel) async throws {
        #expect(mock.original.lastDateOfMonth == mock.expected)
    }

    @Test("get first day of year",
          arguments: [MockModel(original: mockDate, expected: Date("2024-01-1")!),
                      MockModel(original: Date("2024-01-01")!, expected: Date("2024-01-01")!),
                      MockModel(original: Date("2024-12-31")!, expected: Date("2024-01-01")!)])
    func getFirstDayOfYear(mock: MockModel) async throws {
        #expect(mock.original.firstDateOfYear == mock.expected)
    }

    @Test("get last day of year",
          arguments: [MockModel(original: mockDate, expected: Date("2024-12-31")!),
                      MockModel(original: Date("2024-01-01")!, expected: Date("2024-12-31")!),
                      MockModel(original: Date("2024-12-31")!, expected: Date("2024-12-31")!)])
    func getLastDayOfYear(mock: MockModel) async throws {
        #expect(mock.original.lastDateOfYear == mock.expected)
    }
}

// MARK: - MockModel

struct MockModel {
    var toAdd = 0
    var original = Date("2024-09-19")!
    var expected: Date
}
