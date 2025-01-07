//
//  MoodSelectionScreenViewModel.swift
//  Mood Tracker
//
//  Created by FayTek on 1/3/25.
//

import Foundation
import SwiftData
import Observation

@Observable
class SavedMoodViewModel: ObservableObject {
    var selectedDate = Date() {
        didSet {
            updateMonthDay(from: selectedDate)
        }
    }
    var monthDays = [Date]()
    var context: ModelContext?
    private var savedMoods: [Date: Mood] = [:]
    
    var moodValue: Double = 0
    
    var selectedMood: Mood {
        let index = Int(round(moodValue))
        return Mood.allCases[index]
    }
    
    init(context: ModelContext? = nil) {
        self.context = context
        updateMonthDay(from: Date())
    }
    
    private func updateMonthDay(from date: Date) {
        let calendar = Calendar.current
        
        guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
            print("Error: Could not calculate start of month.")
            return
        }
        
        guard let range = calendar.range(of: .day, in: .month, for: startOfMonth) else {
            print("Error: Could not calculate range of days in the month.")
            return
        }
        
        monthDays = range.compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
    }
    
    func moodForDay(date: Date) -> Mood? {
        let normalizedDate = date.normalizedDate
        return savedMoods[normalizedDate] ?? .unknown
    }
    
    func updateMoodValue(sliderXValue: CGFloat, stepWidth: CGFloat, size: CGFloat, trackWidth: CGFloat) {
        let minX: CGFloat = 0
        let maxX: CGFloat = trackWidth - size
        let clampedX = min(max(minX, sliderXValue), maxX)
        
        let step = round(clampedX / stepWidth)
        self.moodValue = Double(step)
    }
    
    @MainActor
    func save(mood: Mood, date: Date) {
        let normalizedDate = date.normalizedDate
        
        if let existingMood = try?
            context?.fetch(FetchDescriptor<SavedMood>()).first(where: { savedMood in
                Calendar.current.isDate(savedMood.date, inSameDayAs: normalizedDate)
            }) {
            existingMood.mood = mood
        } else {
            let savedMood = SavedMood(date: normalizedDate, mood: mood)
            context?.insert(savedMood)
        }
        fetch() // Refresh the saved moods
    }
    
    @MainActor
    func editMood(date: Date, newMood: Mood) {
        let normalizedDate = date.normalizedDate
        
        if let existingMood = try?
            context?.fetch(FetchDescriptor<SavedMood>()).first(where: { savedMood in
                Calendar.current.isDate(savedMood.date, inSameDayAs: normalizedDate)
            }) {
            existingMood.mood = newMood
            fetch() // Refresh the saved moods
        }
    }
    
    @MainActor
    func deleteMood(date: Date) {
        let normalizedDate = date.normalizedDate
        
        if let existingMood = try?
            context?.fetch(FetchDescriptor<SavedMood>()).first(where: { savedMood in
                Calendar.current.isDate(savedMood.date, inSameDayAs: normalizedDate)
            }) {
            context?.delete(existingMood)
            fetch() // Refresh the saved moods
        }
    }
    
    @MainActor
    func fetch() {
        do {
            guard let fetchedMoods = try context?.fetch(FetchDescriptor<SavedMood>()) else { return }
            savedMoods = Dictionary(uniqueKeysWithValues: fetchedMoods.map { ($0.date, $0.mood) })
        } catch {
            print("Error fetching moods: \(error)")
        }
    }
}

extension Date {
    var normalizedDate: Date {
        return Calendar.current.startOfDay(for: self)
    }
}
