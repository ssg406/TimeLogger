//
//  SettingsStack.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/9/24.
//
import SwiftUI
import SwiftData

struct SettingsStack: View {
    
    @Environment(SettingsModel.self) private var settingsModel
    @Query private var entryGroups: [EntryGroup]
    @FocusState private var currencyFocused: Bool
    @State private var newQuickOption: Int?
    
    var body: some View {
        @Bindable var settings = settingsModel
        NavigationStack {
            List {
                
                Section("Time Entry Defaults") {
                        Picker("Default entry group", selection: $settings.defaultGroup) {
                            ForEach(entryGroups) { group in
                                EntryGroupLabel(group: group)
                                    .tag(group)
                            }
                            EntryGroupLabel()
                                .tag(nil as EntryGroup?)
                        }
                    
                    
                    Toggle("Entries default to billable", isOn: $settings.billableDefault)
                    HStack {
                        Text("Default rate")
                        Spacer()
                        CurrencyField(currencyAmount: $settings.defaultRate, isFocused: $currencyFocused)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 10))
                    }
                }
                
                Section("Quick Time Entry Options") {

                    Text("Quick entries are added with default options and the end time set to the current time.")
                        .listRowSeparator(.hidden)
                    HStack {
                        TextField("Time in minutes", value: $newQuickOption, format: .number)
                            .textFieldBackground()
                        
                        
                        Button("Add", systemImage: "plus.circle", action: newQuickAddOption)
                            .listRowSeparator(.hidden)
                    }
                    ForEach(settings.quickAddOptions) { option in
                        HStack {
                            Text(option.label)
                            
                            Button("", systemImage: "minus.circle", action: { removeOption(option) })
                        }
                        .listRowSeparator(.hidden)
                    }
                }

                
                
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
#if os(iOS)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        currencyFocused = false
                    }
                }
            }
#endif
            
        }
    }
    
    private func removeOption(_ option: QuickTimeOption) {
        if let index = settingsModel.quickAddOptions.firstIndex(of: option) {
            settingsModel.quickAddOptions.remove(at: index)
        }
    }
    
    private func newQuickAddOption() {
        guard let newQuickOption = newQuickOption,
              newQuickOption > 0 else { return }
        let option = QuickTimeOption(interval: TimeInterval(60 * newQuickOption))
        settingsModel.quickAddOptions.append(option)
        self.newQuickOption = nil
    }
}



#Preview(traits: .sampleData) {
    SettingsStack()
}
