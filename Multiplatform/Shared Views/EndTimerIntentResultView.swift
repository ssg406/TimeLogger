//
//  EndTimerIntentResultView.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/18/24.
//
import SwiftUI

struct EndTimerIntentResultView: View {
    
    let entry: TimeEntry
    
    var body: some View {
        VStack {
            Text("Logged \(entry.durationString)")
                .font(.headline)
            Text(entry.timeRangeString)
                .font(.subheadline)
        }
    }
}
