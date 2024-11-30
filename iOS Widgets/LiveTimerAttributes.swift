//
//  LiveTimerAttributes.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/6/24.
//

#if canImport(ActivityKit)
import ActivityKit
import Foundation

struct LiveTimerAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var elapsedTime: Duration
    }
    var startTime: Date
}

extension LiveTimerAttributes {
    static var preview: LiveTimerAttributes {
        LiveTimerAttributes(startTime: Date.now - 4000)
    }
}

extension LiveTimerAttributes.ContentState {
    static var underHour: LiveTimerAttributes.ContentState {
        LiveTimerAttributes.ContentState(elapsedTime: Duration.seconds(60 * 28 + 3))
     }
    
    static var underFiveMin: LiveTimerAttributes.ContentState {
        LiveTimerAttributes.ContentState(elapsedTime: Duration.seconds(60 * 3 + 43))
    }
    
    static var overTwoHour: LiveTimerAttributes.ContentState {
        LiveTimerAttributes.ContentState(elapsedTime: Duration.seconds(3600 * 3 + 82))
    }
}
#endif
