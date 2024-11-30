//
//  Settings.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/12/24.
//
import SwiftData
import Foundation

struct QuickTimeOption: Codable, Identifiable, Equatable {
    var id: UUID = UUID()
    var interval: TimeInterval
    
    var label: String {
        Duration.seconds(interval).formatted(.units(allowed: [.minutes]))
    }
    
    static var defaultOptions: [QuickTimeOption] {
        [600, 1200, 1800].map { .init(interval: $0) }
    }
}


@Observable final class SettingsModel {
    var defaultGroup: EntryGroup? { didSet {
        save(defaultGroup, key: "DefaultGroupSetting")
    }}
    var quickAddOptions: [QuickTimeOption] { didSet {
        save(quickAddOptions, key: "QuickAddOptionsSetting")
    }}
    var billableDefault: Bool { didSet {
        save(billableDefault, key: "BillableDefaultSetting")
    }}
    var defaultRate: Double { didSet {
        save(defaultRate, key: "DefaultRateSetting")
    }}
    
    init() {
        
        let defaultGroup = Self.load(EntryGroup.self, key: "DefaultGroupSetting")
        let quickAddOptions = Self.load([QuickTimeOption].self, key: "QuickAddOptionsSetting")
        let billableDefault = Self.load(Bool.self, key: "BillableDefaultSetting")
        let defaultRate = Self.load(Double.self, key: "DefaultRateSetting")
        
        self.defaultGroup = defaultGroup
        self.quickAddOptions = quickAddOptions ?? QuickTimeOption.defaultOptions
        self.billableDefault = billableDefault ?? false
        self.defaultRate = defaultRate ?? 0.0
    }
    
    private func save<T>(_ value: T, key: String) where T: Codable {
        if let data = try? JSONEncoder().encode(value) {
            UserDefaults(suiteName: C.suiteName)?.set(data, forKey: key)
        }
    }
    
    private static func load<T>(_ type: T.Type, key: String) -> T? where T: Codable {
        UserDefaults(suiteName: C.suiteName)?.data(forKey: key).flatMap { try? JSONDecoder().decode(T.self, from: $0)
        }
    }
}
