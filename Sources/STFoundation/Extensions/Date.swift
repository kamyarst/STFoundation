//
//  Date.swift
//
//
//  Created by Kamyar Sehati on 01/04/2023.
//

import Foundation

extension Date {

    public var standardServerFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }

    public var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: self)
    }

    public var dayString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: self)
    }

    public var monthName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self.dateOnly)
    }

    public var day: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: self.dateOnly)
    }

    public var dayOfWeekText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: self.dateOnly)
    }

    public var year: Int { Calendar.current.component(.year, from: self) }

    public var month: Int { Calendar.current.component(.month, from: self) }

    public var week: Int { Calendar.current.component(.weekOfYear, from: self) }

    public var minute: Int { Calendar.current.component(.minute, from: self) }

    public var hour: Int { Calendar.current.component(.hour, from: self) }

    public var dateOnly: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        components.timeZone = .current
        let date = Calendar.current.date(from: components)
        return date ?? Date()
    }

    public var dayOfMonth: Int {
        Calendar.current.dateComponents([.day], from: self).day ?? 0
    }

    public var dayOfYear: Int {
        Calendar.current.ordinality(of: .day, in: .year, for: self) ?? 0
    }

    public var firstDateOfMonth: Date {
        var value = self.dayOfMonth
        value -= 1
        return self.addDay(days: -value)
    }

    public var lastDateOfMonth: Date {
        self.firstDateOfMonth.addMonth(month: 1).addDay(days: -1)
    }

    public func isBetween(lhs: Date, rhs: Date) -> Bool {
        lhs <= self && self <= rhs
    }

    public func addDay(days: Int) -> Date {
        var dateComponent = DateComponents()
        dateComponent.day = days
        return Calendar.current.date(byAdding: dateComponent, to: self)?.dateOnly ?? Date()
    }

    public func addMonth(month: Int) -> Date {
        var dateComponent = DateComponents()
        dateComponent.month = month
        return Calendar.current.date(byAdding: dateComponent, to: self)?.dateOnly ?? Date()
    }

    public func addWeek(week: Int) -> Date {
        var dateComponent = DateComponents()
        dateComponent.day = week * 7
        return Calendar.current.date(byAdding: dateComponent, to: self)?.dateOnly ?? Date()
    }

    public func distance(from date: Date) -> Int {
        Calendar.current.dateComponents([.day], from: self, to: date).day ?? 1
    }

    public func distanceWeek(from date: Date) -> Int {
        abs(self.week - date.week) + 1
    }

    public func distanceMonth(from date: Date) -> Int {
        abs(self.month - date.month) + 1
    }

    public func distanceYear(from date: Date) -> Int {
        abs(self.year - date.year)
    }
}
