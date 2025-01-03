//
//  Mood_TrackerApp.swift
//  Mood Tracker
//
//  Created by FayTek on 1/2/25.
//

import SwiftUI
import SwiftData

@main
struct Mood_TrackerApp: App {
    var body: some Scene {
        WindowGroup {
            MoodSelectionScreen()
            
        }
        .modelContainer(for: SavedMood.self)
    }
}
