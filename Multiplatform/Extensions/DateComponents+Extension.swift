//
//  DateComponents+Extension.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/9/24.
//
import Foundation

extension DateComponents {
    var dateString: String {
        if let date = Calendar.current.date(from: self) {
            date.formatted(date: .abbreviated, time: .omitted)
        } else {
            "--/--/--"
        }
    }
}
