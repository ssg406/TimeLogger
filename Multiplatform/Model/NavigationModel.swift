//
//  NavigationModel.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/9/24.
//
import Observation
import SwiftUI

@Observable class NavigationModel {
    
    var timerSheetVisibility = false
    
    var newGroupSheetVisibility = false
    
    var selectedSection: AppScreen?
    
    var columnVisibility: NavigationSplitViewVisibility
    
    var timeEntriesPath: NavigationPath
    
    var entryGroupsPath: NavigationPath
    
    init(selectedSection: AppScreen? = nil, columnVisibility: NavigationSplitViewVisibility = .all) {

        self.columnVisibility = columnVisibility
        self.selectedSection = selectedSection
        self.timeEntriesPath = NavigationPath()
        self.entryGroupsPath = NavigationPath()
    }
}
