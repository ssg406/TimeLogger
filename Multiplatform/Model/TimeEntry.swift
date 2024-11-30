//
//  TimeEntry.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/6/24.
//
import Foundation
import SwiftData
import SwiftUI

@Model
final public class TimeEntry: Hashable {
    
    // MARK: Properties
    var uuid: String = UUID().uuidString
    var startTime: Date = Date.now
    var endTime: Date?
    var taskDescription: String = ""
    var billable: Bool = false
    var hourlyRate: Double = 0.0
    var entryGroup: EntryGroup?
    
    // MARK: Init
    init(startTime: Date = .now, endTime: Date? = nil, taskDescription: String = "", group: EntryGroup? = nil, billable: Bool = false, hourlyRate: Double = 0.0) {
        self.startTime = startTime
        self.endTime = endTime
        self.taskDescription = taskDescription
        self.entryGroup = entryGroup
        self.billable = billable
        self.hourlyRate = hourlyRate
    }
}

// MARK: Utility functions for TimeEntry
extension TimeEntry {
    
    var duration: Duration {
        return Duration.seconds((endTime ?? Date.now).timeIntervalSince(startTime))
    }
    
    var totalBilled: Double {
        if hourlyRate > 0 {
            return Double(duration.components.seconds) / 3600 * hourlyRate
        }
        return 0
    }
    
    var dateString: String {
        startTime.formatted(date: .abbreviated, time: .omitted)
    }
    
    var dateComponents: DateComponents {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: startTime)
        return components
    }
    
    var durationString: String {
        duration.formatted(.units(allowed: [.hours, .minutes], width: .narrow))
    }
    
    var timeRangeString: String {
        let endTimeString = if let endTime = endTime {
            endTime.formatted(date: .omitted, time: .shortened)
        } else {
            "--:--"
        }
        return "\(startTime.formatted(date: .omitted, time: .shortened)) to \(endTimeString)"
    }
}

// MARK: Sample time entries
extension TimeEntry {
    
    static var randomTimeEntry: TimeEntry {
        let now = Date()

        // Generate random startTime within the last 14 days
        let fourteenDaysAgo = now - 14 * 24 * 60 * 60
        let randomTimeInterval = Double.random(in: 0...14 * 24 * 60 * 60)
        let startTime = fourteenDaysAgo + randomTimeInterval

        // Generate random duration between 1 minute and 6 hours
        let minDurationSeconds = 60
        let maxDurationSeconds = 6 * 60 * 60
        let randomDurationSeconds = Int.random(in: minDurationSeconds...maxDurationSeconds)
        let endTime = startTime + Double(randomDurationSeconds)
        
        // Generate random billing information
        let billable = Bool.random()
        let rate = Double.random(in: 15.0...150.0)
        
        // Attach to random project
        let randomGroup = EntryGroup.examples.randomElement()
        

        return TimeEntry(startTime: startTime, endTime: endTime, group: randomGroup, billable: billable, hourlyRate: billable ? rate : 0.0)
    }
    
    static var blank: TimeEntry {
        TimeEntry(startTime: Date(), endTime: Date())
    }
}
