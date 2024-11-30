//
//  CalendarModel.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/26/24.
//
import EventKit

enum CSVError: Error {
    case invalidRowLength
    case invalidFile
    case malformedDate
}

@Observable
class ImportEventViewModel {
    var store: EKEventStore
    var startDate: Date
    var endDate: Date
    var events: [EKEvent]
    var showFileImporter: Bool = false
    var showSavedAlert: Bool = false
    
    init() {
        store = EKEventStore()
        startDate = Date.now.addingTimeInterval(-7 * 60 * 60 * 24)
        endDate = Date.now
        events = []
    }
    
    func fetchEvents() async {
        
        guard await authorizationStatus() else {
            Log.calendar.error("Unable to access Calendar")
            return
        }
        let predicate: NSPredicate = store.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        events = store.events(matching: predicate)
    }
    
    private func requestAuthorization() async -> Bool {
        do {
            return try await store.requestFullAccessToEvents()
        } catch {
            Log.calendar.error("Error accessing calendar: \(error.localizedDescription)")
            return false
        }
    }
    
    private func authorizationStatus() async -> Bool {
        let status = EKEventStore.authorizationStatus(for: .event)
        
        switch status {
        case .notDetermined:
            let result = await requestAuthorization()
            return result
        case .restricted:
            Log.calendar.error("Calendar access restricted")
            return false
        case .denied:
            Log.calendar.error("Calendar access denied")
            return false
        case .fullAccess:
            return true
        case .writeOnly:
            Log.calendar.error("Calendar access is write only")
            return false
        @unknown default:
            Log.calendar.error("Unknown Calendar access status")
            return false
        }
    }
    
    func readCSV(from file: URL) throws -> [TimeEntry] {
        let csvString = try? String(contentsOf: file, encoding: .utf8)
        guard let csvString = csvString else {
            throw CSVError.invalidFile
        }
        let lines = csvString.split(separator: "\n").map(String.init)
        let entries = try lines.compactMap(parseRow)
        return entries
    }
    
    private func parseRow(_ row: String) throws  -> TimeEntry {
        let components = row.split(separator: ",").map(String.init)
        guard components.count == 4 else {
            throw CSVError.invalidRowLength
        }
        let description = components[0]
        guard let startDate = Date.fromString(components[1]),
              let endDate = Date.fromString(components[2]) else {
            throw CSVError.malformedDate
              }
        return TimeEntry(startTime: startDate, endTime: endDate, taskDescription: description)
    }
}
