//
//  ImportTimeEntries.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/26/24.
//
import SwiftUI
import EventKit

struct ImportTimeEntries: View {
    
    @Environment(ImportEventViewModel.self) private var importEventViewModel
    @Environment(\.modelContext) private var context
    
    var body: some View {
        @Bindable var vm = importEventViewModel
        NavigationStack {
            
            List {
                Section("Import from Calendar") {
                    DatePicker("Start Date", selection: $vm.startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $vm.endDate, displayedComponents: .date)
                    Button("Get Calendar Events") {
                        Task {
                            await vm.fetchEvents()
                        }
                    }
                }
                if !vm.events.isEmpty {
                    Section("Available Events") {
                        ForEach(vm.events, id: \.self) { event in
                            HStack {
                                Text(event.title)
                                    .font(.headline)
                                    .padding(.leading, 3)
                                Text(event.durationString)
                                    .font(.subheadline)
                                Spacer()
                                
                                Button("Import") {
                                    createTimeEntry(from: event)
                                }
                            }
                        }
                    }
                }
                
                Section("Import from File") {
                    Button("Select File") {
                        vm.showFileImporter = true
                    }
                    .fileImporter(isPresented: $vm.showFileImporter, allowedContentTypes: [.commaSeparatedText]) { result in
                        switch result {
                        case .success(let file):
                            readCSV(from: file)
                        case .failure(let failure):
                            Log.view.error("Unable to select import file \(failure)")
                        }
                    }
                }

            }
            .alert("Entry Saved", isPresented: $vm.showSavedAlert) {
                Button("Okay", role: .cancel) {
                    // Cancel
                }
            }
        }
        .navigationTitle("Import Time Entries")
        
        
    }
    
    private func createTimeEntry(from event: EKEvent) {
        let entry = TimeEntry(startTime: event.startDate, endTime: event.endDate, taskDescription: event.title)
        context.insert(entry)
        importEventViewModel.showSavedAlert = true
    }
    
    private func readCSV(from file: URL) {
        do {
            let csvEntries = try importEventViewModel.readCSV(from: file)
            saveEntries(csvEntries)
        } catch {
            Log.view.error("Unable to read CSV file \(error.localizedDescription)")
        }
    }
    
    private func saveEntries(_ entries: [TimeEntry]) {
        entries.forEach { context.insert($0) }
    }
    
    
}
