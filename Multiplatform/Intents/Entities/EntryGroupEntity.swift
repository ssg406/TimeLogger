//
//  EntryGroupEntity.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/7/24.
//
import AppIntents

struct EntryGroupEntity: AppEntity {
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Project"
    static var defaultQuery = EntryGroupEntityQuery()
    var displayRepresentation: DisplayRepresentation {
        .init(title: LocalizedStringResource(stringLiteral: entryGroupName))
    }
    var id: UUID = UUID()
    var entryGroupName: String
    
    init(id: UUID, entryGroupName: String) {
        self.id = id
        self.entryGroupName = entryGroupName
    }
    
    init(_ entryGroup: EntryGroup) {
        self.id = entryGroup.uuid
        self.entryGroupName = entryGroup.name
    }
}
