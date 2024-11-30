//
//  StartTimerIntent.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/7/24.
//
import AppIntents
import SwiftData

struct StartTimerIntent: AppIntent  {
    static var title: LocalizedStringResource = "Start Time Entry"
    static var description: IntentDescription? = IntentDescription("Start recording work time")
    static var openAppWhenRun: Bool = false
    
    @Dependency
    var modelContainer: ModelContainer
    
    @Dependency
    var settingsModel: SettingsModel
    
    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        // record start time or create entry and somehow maintain record, id?
        let context = ModelContext(modelContainer)
        let start = Date()
        UserDefaults(suiteName: C.suiteName)?.set(start, forKey: "StartTimerIntent.StartTime")
        let entry = TimeEntry(startTime: start, group: settingsModel.defaultGroup, billable: settingsModel.billableDefault, hourlyRate: settingsModel.defaultRate)
        context.insert(entry)
        UserDefaults(suiteName: C.suiteName)?.set(entry.uuid, forKey: "StartTimerIntent.EntryID")
        
        let result = IntentResultContainer.result(dialog: "Started logging time at \(start.dateOnly)")
        try await IntentDonationManager.shared.donate(intent: StartTimerIntent(), result: result)
        
        return result
    }
}


