//
//  CreateProjectView.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/11/24.
//
import SwiftUI

struct CreateEntryGroup: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @Bindable private var group: EntryGroup
    private var fromNew: Bool = true
    
    init(group: EntryGroup? = nil, fromNew: Bool = true) {
        self.group = group ?? EntryGroup(name: "")
        self.fromNew = fromNew
    }
    
    var body: some View {
        
        List {
            Text("\(fromNew ? "Create" : "Edit") Group")
                .font(.headline)
                .listRowSeparator(.hidden)
            Section {
                TextField("Group name", text: $group.name)
                    .textInputAutocapitalization(.never)
                    .textFieldBackground()
                    .listRowSeparator(.hidden)

            }
            Section {
                Text("Group Color")
                    .font(.headline)
                ColorLabelChooser(selectedColor: $group.color)
                    .listRowSeparator(.hidden)

            }
            HStack {
                Button("Cancel", action: { dismiss() })
                Button("Save", action: saveProject)
                    .disabled(group.name.isEmpty)
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
            .listRowSeparator(.hidden)

        }
        .listStyle(.inset)
        #if os(macOS)
        .padding()
        #endif
    }
    
    
    private func saveProject() {
        if fromNew {
            modelContext.insert(group)
        }
        dismiss()
    }
}

#Preview(traits: .sampleData) {
    CreateEntryGroup()
}
