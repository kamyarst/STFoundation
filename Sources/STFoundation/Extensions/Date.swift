//
//  Date.swift
//
//
//  Created by Kamyar Sehati on 01/04/2023.
//

import Foundation

public extension Date {

    var standardServerFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }

    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: self)
    }

    var dayString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: self)
    }

    var monthName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self.dateOnly)
    }

    var day: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: self.dateOnly)
    }

    var dayOfWeekText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: self.dateOnly)
    }

    var year: Int { Calendar.current.component(.year, from: self) }

    var month: Int { Calendar.current.component(.month, from: self) }

    var week: Int { Calendar.current.component(.weekOfYear, from: self) }

    var minute: Int { Calendar.current.component(.minute, from: self) }

    var hour: Int { Calendar.current.component(.hour, from: self) }

    var dateOnly: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        components.timeZone = .current
        let date = Calendar.current.date(from: components)
        return date ?? Date()
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
        return self.addDay(days: -value)
    }

    var lastDateOfMonth: Date {
        self.firstDateOfMonth.addMonth(month: 1).addDay(days: -1)
    }

    func isBetween(lhs: Date, rhs: Date) -> Bool {
        lhs <= self && self <= rhs
    }

    func addDay(days: Int) -> Date {
        var dateComponent = DateComponents()
        dateComponent.day = days
        return Calendar.current.date(byAdding: dateComponent, to: self)?.dateOnly ?? Date()
    }

    func addMonth(month: Int) -> Date {
        var dateComponent = DateComponents()
        dateComponent.month = month
        return Calendar.current.date(byAdding: dateComponent, to: self)?.dateOnly ?? Date()
    }

    func addWeek(week: Int) -> Date {
        var dateComponent = DateComponents()
        dateComponent.day = week * 7
        return Calendar.current.date(byAdding: dateComponent, to: self)?.dateOnly ?? Date()
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
