//
//  Log.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/6/24.
//
import OSLog

struct Log {
    static let subsystem = "codes.samueljones.TimeLogger"
    
    static let view = Logger(subsystem: subsystem, category: "[View]")
    static let widget = Logger(subsystem: subsystem, category: "[Widget/Activity]")
    static let data = Logger(subsystem: subsystem, category: "[Data]")
    static let intent = Logger(subsystem: subsystem, category: "[Intent]")
    static let calendar = Logger(subsystem: subsystem, category: "[Calendar]")
}
