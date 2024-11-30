//
//  LiveTimerViewModel.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/6/24.
//

#if canImport(ActivityKit)
import Foundation
import OSLog
import ActivityKit

@Observable class LiveTimerViewModel: ObservableObject {
    
    var timer: Timer?
    var liveActivityElapsedTime = Duration.zero
    
    struct ActivityViewState: Sendable {
        var activityState: ActivityState
        var contentState: LiveTimerAttributes.ContentState
        var isStale: Bool { activityState == .stale }
    }
    
    var activityViewState: ActivityViewState? = nil
    private var currentActivity: Activity<LiveTimerAttributes>? = nil
    
    private func startTimerActivity(for startTime: Date) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            Log.widget.warning("Could not start live activity: live activities are not enabled on the device.")
            return
        }
        do {
            let timerActivity = LiveTimerAttributes(startTime: startTime)
            let initialState = LiveTimerAttributes.ContentState(elapsedTime: .zero)
            
            let activity = try Activity.request(attributes: timerActivity, content: .init(state: initialState, staleDate: nil))
            self.setup(withActivity: activity)
        } catch {
            Log.widget.error("Encountered error creating new live activity: \(error.localizedDescription)")
        }
    }
    
    private func setup(withActivity activity: Activity<LiveTimerAttributes>) {
        self.currentActivity = activity
        
        self.activityViewState = .init(activityState: activity.activityState, contentState: activity.content.state)
        Log.widget.debug("Live activity setup successful")
    }
    
    private func updateTimerActivity(with elapsedTime: Duration) async throws {
        guard let activity = currentActivity else { return }
        let contentState = LiveTimerAttributes.ContentState(elapsedTime: elapsedTime)
        await activity.update(ActivityContent<Activity<LiveTimerAttributes>.ContentState>(
        state: contentState, staleDate: nil
        ))
        Log.widget.debug("Live activity updated")
    }
    
    private func endTimerActivity(with finalDuration: Duration) async {
        guard let activity = currentActivity else { return }
        let finalContent = LiveTimerAttributes.ContentState(elapsedTime: finalDuration)
        await activity.end(ActivityContent(state: finalContent, staleDate: nil), dismissalPolicy: .immediate)
        Log.widget.debug("Live activity ended")
    }
}

/// Public-facing live activity API
extension LiveTimerViewModel {
    func startTimer(_ existingStartTime: Date = Date()) {
       // IntentDonationManager.shared.donate(intent: StartTimerIntent())
        self.startTimerActivity(for: existingStartTime)
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            Task {
                self.liveActivityElapsedTime += .seconds(60)
                try? await self.updateTimerActivity(with: self.liveActivityElapsedTime)
            }
        }
    }
    
    func endTimer() {

        self.timer?.invalidate()
        Task {
            await self.endTimerActivity(with: self.liveActivityElapsedTime)
        }
    }
}
#endif
