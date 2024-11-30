//
//  EntryList.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/8/24.
//
import SwiftUI
import SwiftData

struct EntryList: View {
    
    typealias ListSegment = ([TimeEntry], String, String)
    @Environment(NavigationModel.self) private var navigationModel
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TimeEntry.startTime, order: .reverse)
    private var entries: [TimeEntry]
    
    var body: some View {
        List {
            ForEach(entryDateSet, id: \.self) { date in
                let (entries, hours, dateString) = getEntries(for: date)
                Section {
                    ForEach(entries) { timeEntry in
                        Button {
                            navigationModel.timeEntriesPath.append(timeEntry)
                        } label: {
                            TimeEntryListRow(entry: timeEntry)
                        }
                        .buttonStyle(.plain)
                        .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: deleteEntries)
                } header: {
                    HStack {
                        Text("\(dateString)")
      
                        Spacer()
                        Text(hours)
                    }
                    .font(.headline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.accent.opacity(0.1), in: RoundedRectangle(cornerRadius: 5))
                }
            }
        }
        .listStyle(.inset)
        .toolbar {
            EditButton()
        }
    }
    
    var entryDateSet: [DateComponents] {
        let allDates = entries.map(\.dateComponents)
        let sortedSet = Set(allDates).sorted {
            Calendar.current.date(from: $0) ?? .now > Calendar.current.date(from: $1) ?? .now
        }
        return Array(sortedSet)
    }
    
    private func deleteEntries(at indexSet: IndexSet) {
        for index in indexSet {
            modelContext.delete(entries[index])
        }
    }
    
    private func getEntries(for date: DateComponents) -> ListSegment {
        let entries = entries.filter { $0.dateComponents == date }
        let duration = entries.reduce(Duration.zero) { $0 + $1.duration}
        let hours = duration.formatted(.units(allowed: [.hours, .minutes], width: .narrow))
        
        return (entries, hours, date.dateString)
    }
}

#Preview(traits: .sampleData) {
    @Previewable @Query var entries: [TimeEntry]
    EntryList()
}
