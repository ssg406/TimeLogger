//
//  ContentView.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/5/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(NavigationModel.self) private var navigationModel
    @Environment(\.modelContext) private var context
    @Query private var entries: [TimeEntry]
    
    
    var body: some View {
        @Bindable var navigationModel = navigationModel
        
        NavigationSplitView(columnVisibility: $navigationModel.columnVisibility) {
            
            Sidebar()
            
        } detail: {
            
            if let selectedView = navigationModel.selectedSection {
                selectedView.destination
            } else {
                ContentUnavailableView("Select a section", systemImage: "filemenu.and.selection")
            }
        }
        .onOpenURL(perform: handleURL)
        .onAppear {
            entries.forEach {
                context.delete($0)
            }
        }
    }
    
    private func handleURL(_ url: URL) {
        guard url.scheme == "timeloggerapp" else { return }
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
        guard let action = components.host, action == "open-time-entry" else { return }
        guard let timeEntryID = components.queryItems?.first(where: { $0.name == "entryID" })?.value else { return }
        guard let entry = entries.first(where: { $0.uuid == timeEntryID }) else { return }
        navigationModel.timeEntriesPath.append(entry)
        navigationModel.selectedSection = .entries
    }
}

#Preview(traits: .sampleData) {
    ContentView()
}
