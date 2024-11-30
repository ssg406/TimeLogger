//
//  EntryGroup.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/6/24.
//
import Foundation
import SwiftData
import SwiftUI
import AppIntents

@Model
final public class EntryGroup: Hashable, Codable {
    
    // Maps to id of EntryGroupEntity
    var uuid: UUID = UUID()
    
    // MARK: Properties
    var name: String = ""
    var color: ColorLabel = ColorLabel.blue
    @Relationship(inverse: \TimeEntry.entryGroup) var entries: [TimeEntry]?
    
    // MARK: Computed Properties
    var totalTime: Duration {
        entries?.reduce(Duration.zero, { duration, entry in
            duration + entry.duration
        }) ?? .zero
    }
    
    var totalBilled: Double {
        entries?.map(\.totalBilled)
            .reduce(0, +) ?? 0.0
    }
    
    var displayColor: Color {
        Color[color()]
    }
    
    var totalTimeString: String {
        totalTime.formatted(.units(allowed: [.hours, .minutes], width: .narrow))
    }
    
    var totalBilledString: String {
        totalBilled.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD"))
    }
    
    // MARK: Init
    init(name: String = "", color: ColorLabel = .blue, entries: [TimeEntry] = []) {
        self.name = name
        self.color = color
        self.entries = entries
    }
    
    // MARK: Codable conformance
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try container.decode(UUID.self, forKey: .uuid)
        name = try container.decode(String.self, forKey: .name)
        color = try container.decode(ColorLabel.self, forKey: .color)
        // entries is not decoded
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(name, forKey: .name)
        try container.encode(color, forKey: .color)
        // entries is not encoded
    }
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case name
        case color
    }

}

// MARK: Model Utilities
extension EntryGroup {
    static let examples: [EntryGroup] = [
        EntryGroup(name: "Crusher Industries", color: .blue),
        EntryGroup(name: "Enterprise", color: .yellow),
        EntryGroup(name: "Data Ltd", color: .mint),
        EntryGroup(name: "LaForge Systems", color: .orange)
    ]
    
    var entity: EntryGroupEntity {
        EntryGroupEntity(self)
    }
}
