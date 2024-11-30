//
//  TimeEntryStack.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/9/24.
//
import SwiftUI
import SwiftData

struct TimeEntryStack: View {
    
    @Environment(NavigationModel.self) private var navigationModel
    @Query
    private var timeEntries: [TimeEntry]
    
    var body: some View {
        @Bindable var navigationModel = navigationModel
        
        NavigationStack(path: $navigationModel.timeEntriesPath) {
            if timeEntries.isEmpty {
                ContentUnavailableView("No entries logged", systemImage: "clock.badge.questionmark")
            } else {
                EntryList()
                    .navigationDestination(for: TimeEntry.self, destination: { entry in
                        EditEntryView(entry: entry)
                    })
            }
        }
        .navigationTitle("All Entries")
    }
}

#Preview(traits: .sampleData) {
    TimeEntryStack()
}
