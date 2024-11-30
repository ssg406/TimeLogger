//
//  StopTimerIntent.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/23/24.
//
import AppIntents
import SwiftData

struct StopTimerIntent: AppIntent {
    static var title: LocalizedStringResource = "Stop Time Entry"
    static var description: IntentDescription = .init("Stop recording work time")
    static var openAppWhenRun: Bool = false
    
    @Dependency
    var modelContainer: ModelContainer
    
    @MainActor
    func perform() async throws -> some IntentResult & ShowsSnippetView & ProvidesDialog {
        
        let context = ModelContext(modelContainer)
        let end = Date()
        
        guard let id = UserDefaults(suiteName: C.suiteName)?.string(forKey: "StartTimerIntent.EntryID") else {
            // throw error?
            return .result(dialog: "No in progress entry found")
        }
        let fetchDescriptor = FetchDescriptor<TimeEntry>(predicate: #Predicate {
            $0.uuid == id
        })
        
        let entries = try context.fetch(fetchDescriptor)
        
        guard let openEntry = entries.first else {
            // throw error?
            return .result(dialog: "No in progress entry found")
        }
        openEntry.endTime = end
        try context.save()
        
        let result = IntentResultContainer.result(
            dialog: "Time logging complete",
            view: EndTimerIntentResultView(entry: openEntry)
        )
        
        // Donate intent
        try await IntentDonationManager.shared.donate(intent: StopTimerIntent(), result: result)
        
        return result
    }
}
