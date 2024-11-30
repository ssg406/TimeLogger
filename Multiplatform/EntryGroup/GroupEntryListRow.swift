//
//  GroupEntryListRow.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/19/24.
//
import SwiftUI

struct GroupEntryListRow: View {
    
    let entry: TimeEntry
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 16) {
            VStack(alignment: .leading) {
                
                if entry.taskDescription.isNotEmpty {
                    Text(entry.taskDescription)
                        .font(.caption)
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(entry.dateString)
                    .font(.caption)
                Text(entry.timeRangeString)
                    .font(.caption)
            }
        }
        .padding(.vertical, 1)
        .listRowSeparator(.hidden)
    }
}
