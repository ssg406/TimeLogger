//
//  EntryGroupEntityQuery.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/7/24.
//
import AppIntents
import SwiftData

struct EntryGroupEntityQuery: EntityQuery {
    
    typealias Entity = EntryGroupEntity
    
    @Dependency(key: C.containerDependency)
    var modelContainer: ModelContainer
    
    func entities(for identifiers: [UUID]) async throws -> [EntryGroupEntity] {
        fetchEntryGroups()
            .map(\.entity)
            .filter { identifiers.contains($0.id) }
    }
    
    func suggestedEntities() async throws -> [Entity] {
        // TODO: Add method to return frequently used/with most entries Expand in the future
        fetchEntryGroups()
            .sorted { $0.entries?.count ?? 0 > $1.entries?.count ?? 0 }
            .prefix(5)
            .map(\.entity)
    }
    
    func fetchEntryGroups() -> [EntryGroup] {
        let context = ModelContext(modelContainer)
        let fetchDescriptor = FetchDescriptor<EntryGroup>()
        
        do {
            let entryGroups = try context.fetch(fetchDescriptor)
            return entryGroups
        } catch {
            Log.intent.error("Failed to fetch entry groups: \(error)")
            return []
        }
    }
}

extension EntryGroupEntityQuery: EntityStringQuery {
    func entities(matching string: String) async throws -> [EntryGroupEntity] {
        fetchEntryGroups()
            .filter { $0.name.contains(string) }
            .map(\.entity)
    }
}
