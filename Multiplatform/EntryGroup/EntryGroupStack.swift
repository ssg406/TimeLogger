//
//  EntryGroupStack.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/9/24.
//
import SwiftUI
import SwiftData

struct EntryGroupStack: View {
    
    @Environment(NavigationModel.self) private var navigationModel
    @Query private var entryGroups: [EntryGroup]
    
    var body: some View {
        @Bindable var navigationModel = navigationModel
        
        NavigationStack(path: $navigationModel.entryGroupsPath) {
            if entryGroups.isEmpty {

                ContentUnavailableView {
                    Label("No groups created", systemImage: "folder.badge.questionmark")
                } description: {
                    Text("Would you like to add a new group?")
                } actions: {
                    Button("New Group", systemImage: "plus") {
                        navigationModel.newGroupSheetVisibility = true
                    }
                }

            } else {
                EntryGroupList()
                    .navigationDestination(for: EntryGroup.self, destination: { group in
                        CreateEntryGroup(group: group, fromNew: false)
                    })
            }
        }
        .sheet(isPresented: $navigationModel.newGroupSheetVisibility) {
            CreateEntryGroup()
        }
        .toolbar {
            ToolbarItem {
                Button("New Group", systemImage: "plus") {
                    navigationModel.newGroupSheetVisibility = true
                }
            }
        }
        .navigationTitle("Entry Groups")
    #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
    #endif
    }
}

#Preview(traits: .sampleData) {
    EntryGroupStack()
}
