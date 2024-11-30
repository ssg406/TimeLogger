//
//  LiveTimerActivityView.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/6/24.
//

#if canImport(ActivityKit)
import WidgetKit
import SwiftUI

struct LiveTimerActivityView: View {
    let state: LiveTimerAttributes.ContentState
    let startTime: Date
    let isStale: Bool
    
    var body: some View {
        HStack {
            LiveTimerStartTimeView(startTime: startTime)
            Spacer()
            LiveTimerImageView()
                .font(.system(size: 40.0))
                .foregroundStyle(.green)
            Spacer()
            VStack {
                LiveTimerTimeView(seconds: TimeInterval(state.elapsedTime.components.seconds), startTime: startTime)
                    .font(.title)
            }
        }
        .padding()
    }
}

struct LiveTimerActivityImage: View {
    var body: some View {
        Image(systemName: "hourglass")
    }
}

struct LiveTimerStartTimeView: View {
    let startTime: Date
    var body: some View {
        VStack(alignment: .leading) {
            Text("Active Since".uppercased())
                .font(.caption2)
            Text(startTime.formatted(date: .omitted, time: .shortened))
                .bold()
        }
    }
    
}

struct LiveTimerTimeView: View {
    let seconds: TimeInterval
    let startTime: Date
    var minimal: Bool = false

    // TODO: fix formatting issue, compact variant takes up huge width, set max width with .min(x,y)
    var body: some View {
        // Display times under 10m with count up timer
        VStack {
            if seconds <= 60 * 10 {
                        Text(timerInterval: startTime...Date.now + 8 * 3600, countsDown: false, showsHours: true)
            } else {
                // Over 10m times formatted without counter
                Text(minimal ? seconds.textTimeString : seconds.durationString)

            }
        }
        .frame(maxWidth: 50)

    }
}

struct LiveTimerImageView: View {
    var body: some View {
        Image(systemName: "hourglass")
    }
}

#Preview("Notification", as: .content, using: LiveTimerAttributes.preview) {
   TimerActivityConfiguration()
} contentStates: {
    LiveTimerAttributes.ContentState.overTwoHour
}

#endif
