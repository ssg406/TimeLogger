//
//  DataModel.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/6/24.
//
import SwiftUI
import SwiftData

actor DataModel {
    static let shared = DataModel()
    private init() {}
    
    nonisolated lazy var modelContainer: ModelContainer = {
        let modelContainer: ModelContainer
        do {
            modelContainer = try ModelContainer(for: TimeEntry.self)
        } catch {
            fatalError("Failed to create the model container: \(error)")
        }

        return modelContainer
    }()
}
