//
//  Color+Extension.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/6/24.
//
import SwiftUI

extension Color {
    static subscript(_ name: String) -> Color {
        switch(name) {
        case "blue": return .blue
        case "brown": return .brown
        case "cyan": return .cyan
        case "gray": return .gray
        case "green": return .green
        case "indigo": return .indigo
        case "mint": return .mint
        case "orange": return .orange
        case "pink": return .pink
        case "purple": return .purple
        case "red": return .red
        case "teal": return .teal
        case "yellow": return .yellow
        default: return .primary
        }
    }
}
