//
//  Sidebar.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/12/24.
//
import SwiftUI
import SwiftData

struct Sidebar: View {
    
    @Environment(NavigationModel.self) private var navigationModel
    @Environment(SettingsModel.self) private var settingsModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(TimerModel.self) private var timerModel
    @State private var showQuickAddDialog = false
    
    var body: some View {
        @Bindable var navigationModel = navigationModel
        VStack {
            Text("Time Logger")
                .font(.title)
                .bold()
                .padding(.horizontal)
                .foregroundStyle(.accent)
            
            List(selection: $navigationModel.selectedSection) {
                ForEach(AppScreen.allCases) { section in
                    NavigationLink(value: section) {
                        section.label
                    }
                }
                
                Button("Quick Log", systemImage: "plus") {
                    showQuickAddDialog = true
                }
                .buttonStyle(.plain)
                
                TimerButton()
            }
            #if os(iOS)
            .listStyle(.plain)
            #endif
                Group {
                    if timerModel.isTimerActive {
                        Text(timerInterval: timerModel.start...Date.now + 8 * 3600, countsDown: false, showsHours: true)
                    } else {
                        Text("0:00")
                    }
                }
                .font(.title)
                .bold()
                .foregroundStyle(.accent)
                .padding(.bottom)
            }
        #if os(iOS)
        .alert("Add Quick Entry", isPresented: $showQuickAddDialog) {
            ForEach(settingsModel.quickAddOptions) { option in
                Button(option.label) {
                    let backDatedStart = Date.now - option.interval
                    let entry = TimeEntry(startTime: backDatedStart, endTime: .now)
                    modelContext.insert(entry)
                    showQuickAddDialog = false
                }
            }
            Button("Cancel", role: .cancel) { }
        }
        #else
        .sheet(isPresented: $showQuickAddDialog) {
            VStack {
                Text("Add Quick Entry")
                    .font(.headline)
                HStack {
                    ForEach(settingsModel.quickAddOptions) { option in
                        Button(option.label) {
                            let backDatedStart = Date.now - option.interval
                            let entry = TimeEntry(startTime: backDatedStart, endTime: .now)
                            modelContext.insert(entry)
                            showQuickAddDialog = false
                        }
                        .padding(.horizontal)
                    }
                    Button("Cancel", role: .cancel) {
                        showQuickAddDialog = false
                    }
                    .padding(.horizontal)
                }
            }
        }
        #endif
    }
}
