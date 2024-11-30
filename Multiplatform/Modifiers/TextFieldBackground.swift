//
//  TextFieldBackground.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/18/24.
//
import SwiftUI

struct TextFieldBackground: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(.primary.opacity(0.05), in: RoundedRectangle(cornerRadius: 10))
    }
}

extension View {
    func textFieldBackground() -> some View {
        modifier(TextFieldBackground())
    }
}
