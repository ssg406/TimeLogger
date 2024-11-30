//
//  EditTimeEntry.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/11/24.
//
import SwiftUI
import SwiftData


struct EditEntryView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @Environment(NavigationModel.self) private var navigationModel
    @Bindable var entry: TimeEntry
    @Query var groups: [EntryGroup]
    @FocusState private var isCurrencyInputActive
    @FocusState private var isDescriptionInputActive
    
    var body: some View {
        @Bindable var navigationModel = navigationModel
            List {
                Section {
                    DatePicker("Start Time", selection: $entry.startTime)
                    
                    if entry.endTime != nil {
                        DatePicker("End Time",
                                   selection: Binding<Date>(
                                    get: { entry.endTime == nil ? Date() : entry.endTime! },
                                    set: { entry.endTime = $0 }
                                )
                        )
                    } else {
                        HStack {
                            Text("End Time")
                            Spacer()
                            Text("In progress")
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 10))
                        }
                    }

                    HStack {
                        Text("Duration")
                        Spacer()
                        Text(entry.durationString)
                    }
                }
                Section {
                    TextField("Description", text: $entry.taskDescription, axis: .vertical)
                        .focused($isDescriptionInputActive)
                }
                Section {
                    Picker("Entry Group", selection: $entry.entryGroup) {
                        Text("No Group")
                            .tag(nil as EntryGroup?)
                        ForEach(groups) { group in
                            Text(group.name)
                                .tag(group as EntryGroup?)
                        }
                    }
                    #if os(iOS)
                    .pickerStyle(.navigationLink)
                    #endif
                    Button("New Entry Group") {
                        navigationModel.newGroupSheetVisibility = true
                    }
                }
                
                Section {
                    Toggle("Billable", isOn: $entry.billable)
                    if entry.billable {
                        HStack {
                            Text("Hourly Rate")
                            Spacer()
                            CurrencyField(currencyAmount: $entry.hourlyRate, isFocused: $isCurrencyInputActive)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 10))

                        }
                    }
                }
            }
            .sheet(isPresented: $navigationModel.newGroupSheetVisibility) {
                CreateEntryGroup()
            }
        #if os(iOS)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isCurrencyInputActive = false
                        isDescriptionInputActive = false
                    }
                }
            }
        #endif
            .navigationTitle("Time Entry")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
        }

}
