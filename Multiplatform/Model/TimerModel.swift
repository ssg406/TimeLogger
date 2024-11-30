//
//  TimerModel.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/6/24.
//
import Foundation
import SwiftUI
import AppIntents

// TODO: Check timer is not resuming when it should be stopped

@Observable final class TimerModel {
    
    var isTimerActive: Bool = false
    var timeEntry: TimeEntry?
    private(set) var startTime: Date? {
        didSet {

            if let startTime = startTime {
                UserDefaults(suiteName: C.suiteName)?.setValue(dateFormatter.string(from: startTime), forKey: C.startTime)
            } else {
                UserDefaults(suiteName: C.suiteName)?.setValue(nil, forKey: C.startTime)
            }
        }
    }
    private(set) var endTime: Date?
    private var timer: Timer?
    
    @ObservationIgnored
    private var dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
       return formatter
    }()
    
    var start: Date {
        startTime ?? Date()
    }
    
    var end: Date {
        endTime ?? Date()
    }
  
    init() {
        guard let existingStartTimeString = UserDefaults(suiteName: C.suiteName)?.string(forKey: C.startTime),
        let existingStartTime = dateFormatter.date(from: existingStartTimeString) else { return }
        
        self.startTime = existingStartTime
        self.startTimer()
    }
    
    func startTimer(_ existingStartTime: Date = Date()) {
        self.startTime = existingStartTime
        isTimerActive = true
    }
    
    func endTimer() {
        isTimerActive = false
        self.endTime = Date()
        // Erase saved start time
        startTime = nil
    }
}
