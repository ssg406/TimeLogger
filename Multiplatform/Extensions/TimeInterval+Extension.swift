//
//  TimeInterval+Extension.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/26/24.
//
import Foundation

extension TimeInterval {
    var durationString: String {
        if self > 3600 {
            return Duration.seconds(self).formatted(.units(allowed: [.hours, .minutes], width: .narrow))
        } else {
            // Over five minutes
            return Duration.seconds(self).formatted(.units(allowed: [.minutes], width: .narrow))
        }
    }
    
    var textTimeString: String {
        Duration.seconds(self).formatted(.time(pattern: .hourMinute))
    }
}
