//
//  Date.swift
//
//
//  Created by Kamyar Sehati on 01/04/2023.
//

import Foundation

public extension Date {

    var year: Int { Calendar.current.component(.year, from: self) }

    var month: Int { Calendar.current.component(.month, from: self) }

    var week: Int { Calendar.current.component(.weekOfYear, from: self) }

    var minute: Int { Calendar.current.component(.minute, from: self) }

    var hour: Int { Calendar.current.component(.hour, from: self) }

    var dateOnly: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components)!
    }

    var endOfDay: Date {
        self.dateOnly.addDay(1).addingTimeInterval(-1)
    }

    var dayOfMonth: Int {
        Calendar.current.dateComponents([.day], from: self).day ?? 0
    }

    var dayOfYear: Int {
        Calendar.current.ordinality(of: .day, in: .year, for: self) ?? 0
    }

    var firstDateOfMonth: Date {
        var value = self.dayOfMonth
        value -= 1
        return self.addDay(-value).dateOnly
    }

    var lastDateOfMonth: Date {
        self.firstDateOfMonth.addMonth(1).addingTimeInterval(-1)
    }

    var firstDateOfYear: Date {
        var value = self.dayOfYear
        value -= 1
        return self.addDay(-value).dateOnly
    }

    var lastDateOfYear: Date {
        self.firstDateOfYear.addYear(1).addingTimeInterval(-1)
    }

    init?(_ string: String, format: String = "yyyy-MM-dd") {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = .current

        guard let date = dateFormatter.date(from: string) else { return nil }
        self = date
    }

    /// Initializes a Date object from an ISO 8601 formatted string.
    /// - Parameter iso8601String: The string containing the date in ISO 8601 format.
    init?(iso8601String: String) {
        let formatter = ISO8601DateFormatter()
        // Adjust the formatter to your specific needs. By default, it handles the most common ISO 8601 formats.

        guard let date = formatter.date(from: iso8601String) else { return nil }
        self = date
    }

    func isBetween(lhs: Date, rhs: Date) -> Bool {
        lhs <= self && self <= rhs
    }

    func addDay(_ day: Int) -> Date {
        var dateComponent = DateComponents()
        dateComponent.day = day
        return Calendar.current.date(byAdding: dateComponent, to: self)!
    }

    func addMonth(_ month: Int) -> Date {
        var dateComponent = DateComponents()
        dateComponent.month = month
        return Calendar.current.date(byAdding: dateComponent, to: self)!
    }

    func addWeek(_ week: Int) -> Date {
        var dateComponent = DateComponents()
        dateComponent.day = week * 7
        return Calendar.current.date(byAdding: dateComponent, to: self)!
    }

    func addYear(_ year: Int) -> Date {
        var dateComponent = DateComponents()
        dateComponent.year = year
        return Calendar.current.date(byAdding: dateComponent, to: self)!
    }

    func distance(from date: Date) -> Int {
        Calendar.current.dateComponents([.day], from: self, to: date).day ?? 1
    }

    func distanceWeek(from date: Date) -> Int {
        abs(self.week - date.week) + 1
    }

    func distanceMonth(from date: Date) -> Int {
        abs(self.month - date.month) + 1
    }

    func distanceYear(from date: Date) -> Int {
        abs(self.year - date.year)
    }
}
