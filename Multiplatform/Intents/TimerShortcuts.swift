//
//  TimerShortcuts.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/7/24.
//

import AppIntents

struct TimerShortcutsProvider: AppShortcutsProvider {
    
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        
        AppShortcut(
            intent: StartTimerIntent(),
            phrases: [
                "Start \(.applicationName)",
                "Start task timer",
                "Start a work timer",
                "Start a new time entry",
                "Start logging time",
                "Start a new work entry"
            ],
            shortTitle: "Start Work Timer",
            systemImageName: "stopwatch"
        )
        
        AppShortcut(
            intent: StopTimerIntent(),
            phrases: [
                "Stop \(.applicationName)",
                "Stop logging time",
                "Stop recording time",
                "End time entry",
                "End the time entry"
            ],
            shortTitle: "End Time Logger",
            systemImageName: "stop"
        )
    }
}
