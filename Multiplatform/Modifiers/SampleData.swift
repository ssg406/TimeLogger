//
//  SampleData.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/6/24.
//
import SwiftData
import SwiftUI

/**
 Preview sample data.
 */
struct SampleData: PreviewModifier {
    static func makeSharedContext() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            configurations: config
        )
        SampleData.createSampleData(into: container.mainContext)
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        let liveTimerViewModel = LiveTimerViewModel()
        let navigationModel = NavigationModel()
        let settingsModel = SettingsModel()
        let ImportEventViewModel = ImportEventViewModel()
        
          return content
            .modelContainer(context)
            .environment(navigationModel)
            .environment(liveTimerViewModel)
            .environment(settingsModel)
            .environment(ImportEventViewModel)
            
    }
    
    static func createSampleData(into modelContext: ModelContext) {
        Task { @MainActor in
            
            EntryGroup.examples.forEach { modelContext.insert($0) }
            
            for _ in 0..<5 {
                modelContext.insert(TimeEntry.randomTimeEntry)
            }
            
            try? modelContext.save()
        }
    }
}

@available(iOS 18.0, *)
extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var sampleData: Self = .modifier(SampleData())
}
