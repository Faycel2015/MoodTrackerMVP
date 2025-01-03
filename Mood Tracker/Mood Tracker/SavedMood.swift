//
//  SavedMood.swift
//  Mood Tracker
//
//  Created by FayTek on 1/3/25.
//

import Foundation
import SwiftData

@Model
class SavedMood {
    var date: Date
    var mood: Mood
    
    init(date: Date, mood: Mood) {
        self.date = date
        self.mood = mood
    }
}
