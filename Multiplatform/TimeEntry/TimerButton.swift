//
//  TimerButton.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/12/24.
//
import SwiftUI
import SwiftData

struct TimerButton: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(TimerModel.self) private var timerModel
#if canImport(ActivityKit)
    @Environment(LiveTimerViewModel.self) private var liveTimerViewModel
#endif
    let entry: TimeEntry = TimeEntry()
    
    var body: some View {
        Button(
            timerModel.isTimerActive ? "Stop Timer" : "Start Timer",
            systemImage: timerModel.isTimerActive ? "stop.fill" : "play.fill"
        ) {
            pushTimerButton()
        }
        .buttonStyle(.plain)
    }
    
    private func pushTimerButton() {
        if timerModel.isTimerActive {
            timerModel.endTimer()
            entry.endTime = timerModel.end
#if canImport(ActivityKit)
            liveTimerViewModel.endTimer()
#endif
        } else {
            timerModel.startTimer()
            entry.startTime = timerModel.start
            modelContext.insert(entry)
#if canImport(ActivityKit)
            liveTimerViewModel.startTimer()
#endif
        }
    }
}
