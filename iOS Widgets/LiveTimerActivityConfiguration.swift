//
//  LiveTimerActivityConfiguration.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/6/24.
//

#if canImport(ActivityKit)
import WidgetKit
import SwiftUI

struct TimerActivityConfiguration: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveTimerAttributes.self) { context in
            // Lock screen / Home screen banner
            LiveTimerActivityView(
                state: context.state,
                startTime: context.attributes.startTime,
                isStale: context.isStale)
            // TODO: Specify background here if needed
        } dynamicIsland: { context in
            DynamicIsland {
                expandedContent(startTime: context.attributes.startTime, state: context.state, isStale: context.isStale)
            } compactLeading: {
                LiveTimerImageView()
                    .foregroundStyle(Color.green)
                    .padding(.leading, 3)
            } compactTrailing: {
                LiveTimerTimeView(seconds: TimeInterval(context.state.elapsedTime.components.seconds), startTime: context.attributes.startTime)
            } minimal: {
                LiveTimerTimeView(seconds: TimeInterval(context.state.elapsedTime.components.seconds), startTime: context.attributes.startTime, minimal: true)
                    .font(.caption2)
            }
            
        }
        
    }
    
    /// Builder for expanded live activity view around dynamic island
    @DynamicIslandExpandedContentBuilder
    func expandedContent(startTime: Date, state: LiveTimerAttributes.ContentState, isStale: Bool
    ) -> DynamicIslandExpandedContent<some View> {
        DynamicIslandExpandedRegion(.leading) {
            LiveTimerStartTimeView(startTime: startTime)
                .padding([.top, .leading])
        }
        
        DynamicIslandExpandedRegion(.center) {
            LiveTimerImageView()
                .font(.largeTitle)
                .foregroundStyle(Color.green)
        }
        
        DynamicIslandExpandedRegion(.trailing) {
            VStack(alignment: .leading) {
                LiveTimerTimeView(seconds: TimeInterval(state.elapsedTime.components.seconds), startTime: startTime)
     
                Button(intent: StopTimerIntent()) {
                    Image(systemName: "stop")
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity)
            .padding([.top, .trailing])
            
            
            // TODO: Add stop timer button to .bottom or .leading
            // TODO: Add $ amount in expanded view when billing amount is added
            // TODO: Incorporate project colors when they exist
        }
        
    }
    
}
#endif


