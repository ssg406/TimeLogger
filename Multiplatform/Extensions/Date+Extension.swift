//
//  Date+Extension.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/6/24.
//


import Foundation
import SwiftData

extension Date {
    
    var dateOnly: String {
        self.formatted(date: .abbreviated, time: .omitted)
    }
    
    static func fromString(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        return formatter.date(from: dateString)
    }
//
//    static var startOfDay: Date {
//        Calendar.current.startOfDay(for: Date.now)
//    }
//    
//    var isCurrentDay: Bool {
//        self > Date.startOfDay
//    }
    

}
