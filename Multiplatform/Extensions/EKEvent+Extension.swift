//
//  EKEvent+Extension.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/26/24.
//
import EventKit

extension EKEvent {
    
    var durationString: String {
        self.endDate.timeIntervalSince(self.startDate).durationString
    }
}
