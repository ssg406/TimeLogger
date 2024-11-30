//
//  AppScreen.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/8/24.
//
import SwiftUI

enum AppScreen: Codable, Hashable, CaseIterable, Identifiable {
    case entries
    case groups
    case settings
    case importEntries
    
    var id: AppScreen { self }
}

extension AppScreen {
    
    @ViewBuilder
    var label: some View {
        switch self {
        case .entries:
            Label("All Entries", systemImage: "list.bullet")
        case .groups:
            Label("Entry Groups", systemImage: "folder")
        case .settings:
            Label("Settings", systemImage: "gear")
        case .importEntries:
            Label("Import Entries", systemImage: "arrow.2.circlepath.circle")
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .entries:
            TimeEntryStack()
        case .groups:
            EntryGroupStack()
        case .settings:
            SettingsStack()
        case .importEntries:
            ImportTimeEntries()
        }
    }
}
