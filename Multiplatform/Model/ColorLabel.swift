//
//  ColorLabel.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/6/24.
//


import Foundation
import SwiftUI

enum ColorLabel: String, Codable, CaseIterable {
    case blue, brown, cyan, gray, green, indigo, mint, orange, pink, purple, red, teal, yellow

    func callAsFunction() -> String {
        return self.rawValue
    }
}