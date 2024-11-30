//
//  EntryGroupLabel.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/7/24.
//
import SwiftUI

struct EntryGroupLabel: View {
    
    var group: EntryGroup?
  
    var body: some View {
        HStack {
            if let group = group {
                Text(group.name)
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(group.displayColor)
            }
        }
    }
}

