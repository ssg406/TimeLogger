//
//  EntryGroupList.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/19/24.
//
import SwiftUI
import SwiftData

struct EntryGroupList: View {
    
    @Environment(\.modelContext) private var context
    @Environment(NavigationModel.self) private var navigationModel
    @Query(sort: \EntryGroup.name)
    private var entryGroups: [EntryGroup]
    
    var body: some View {
        List {
            ForEach(entryGroups) { group in
                
                Section {
                    ForEach(group.entries ?? []) { entry in
                        Button {
                            // TODO: This link maybe should be taken out since it moves the user to a different stack
                            navigationModel.timeEntriesPath.append(entry)
                            navigationModel.selectedSection = .entries
                        } label: {
                            GroupEntryListRow(entry: entry)
                        }
                        .buttonStyle(.plain)
                        .listRowSeparator(.hidden)
                    }
                    
                } header: {
                        Button {
                            navigationModel.entryGroupsPath.append(group)
                        } label: {
                            HStack {
                                Label(group.name, systemImage: "folder")
                                Spacer()
                                Text(group.totalTimeString)
                            }
                            .font(.headline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(group.displayColor.opacity(0.1), in: RoundedRectangle(cornerRadius: 5))
                        }
                        .buttonStyle(.plain)
                        .listRowInsets(EdgeInsets()) // This removes default padding
                }
            }
            .onDelete(perform: delete)
        }
        .listStyle(.plain)
    }
    
    private func delete(at indexSet: IndexSet) {
        indexSet.forEach {
            context.delete(entryGroups[$0])
        }
    }
}

#Preview(traits: .sampleData) {
    EntryGroupList()
}
