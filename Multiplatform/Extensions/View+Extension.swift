//
//  View+Extension.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/6/24.
//


import SwiftUI

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}