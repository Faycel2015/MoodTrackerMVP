//
//  Mood_TrackerApp.swift
//  Mood Tracker
//
//  Created by FayTek on 1/2/25.
//

import SwiftUI
import SwiftData

@main
struct MoodTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(for: SavedMood.self)
    }
}
