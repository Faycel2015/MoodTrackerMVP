//
//  MoodSelectionScreenViewModel.swift
//  Mood Tracker
//
//  Created by FayTek on 1/3/25.
//

import Foundation
import SwiftData
import Observation

@Observable class SavedMoodViewModel {
    var selectedDate = Date() {
        didSet {
            updateMonthDay(from: selectedDate)
        }
    }
    var monthDays = [Date]()
    private var context: ModelContext?
    private var savedMoods: [Date: Mood] = [:]
    
    var moodValue: Double = 0
    
    var selectedMood: Mood {
        let index = Int(round(moodValue))
        return Mood.allCases[index]
    }
    
    init(context: ModelContext? = nil) {
        self.context = context
        fetch()
        updateMonthDay(from: Date())
    }
    
    func moodForDay(date: Date) -> Mood? {
        return savedMoods[date] ?? .unknown
    }
    
    private func updateMonthDay(from date: Date) {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        
        monthDays = range.compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
    }
    
    func updateMoodValue(sliderXValue: CGFloat, stepWidth: CGFloat, size: CGFloat, trackWidth: CGFloat) {
        let minX: CGFloat = 0
        let maxX: CGFloat = trackWidth - size
        let clampedX = min(max(minX, sliderXValue), maxX)
        
        let step = round(clampedX / stepWidth)
        self.moodValue = Double(step)
    }
    
    // Save mood to Swift Data
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
    }
    
    // Fetch mood from Swift Data
    func fetch() {
        do {
            guard let fetchedMoods = try context?.fetch(FetchDescriptor<SavedMood>()) else { return }
            savedMoods = Dictionary(uniqueKeysWithValues: fetchedMoods.map { ($0.date, $0.mood) })
        } catch {
            print(error)
        }
    }
}

extension Date {
    var normalizedDate: Date {
        return Calendar.current.startOfDay(for: self)
    }
}
