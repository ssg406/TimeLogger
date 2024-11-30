//
//  TimeLoggerApp.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/5/24.
//

import SwiftUI
import SwiftData
import AppIntents

// Entry point for iOS + macOS
@main
struct TimeLoggerApp: App {
    
    private var modelContainer: ModelContainer
    private var navigationModel: NavigationModel
    private var timerModel: TimerModel
    private var settingsModel: SettingsModel
    private var importEventViewModel: ImportEventViewModel
    #if canImport(ActivityKit)
    private var liveTimerViewModel: LiveTimerViewModel
    #endif
    
    init() {
        let container = DataModel.shared.modelContainer
        modelContainer = container
        
        let navModel = NavigationModel()
        navigationModel = navModel
        
        let timerModel = TimerModel()
        self.timerModel = timerModel
        
        #if canImport(ActivityKit)
        let liveTimerViewModel = LiveTimerViewModel()
        self.liveTimerViewModel = liveTimerViewModel
        #endif
        
        let settings = SettingsModel()
        self.settingsModel = settings
        
        self.importEventViewModel = ImportEventViewModel()
        
        /// Add app dependencies to manager to ensure availability outside the context of the UI
        AppDependencyManager.shared.add(dependency: container)
        AppDependencyManager.shared.add(dependency: navModel)
        AppDependencyManager.shared.add(dependency: settings)
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
                .environment(navigationModel)
                .environment(timerModel)
                .environment(settingsModel)
                .environment(importEventViewModel)
            #if canImport(ActivityKit)
                .environment(liveTimerViewModel)
            #endif
        }
        #if os(macOS)
        .defaultSize(CGSize(width: 700, height: 500))
        #endif
    }
}
