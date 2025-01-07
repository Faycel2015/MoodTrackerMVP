//
//  MoodHistoryView.swift
//  Mood Tracker
//
//  Created by FayTek on 1/3/25.
//

import SwiftUI
import SwiftData

struct MoodHistoryView: View {
    @Bindable var viewModel: SavedMoodViewModel
    
    // Initialize with a viewModel
    init(viewModel: SavedMoodViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Header with Month Navigation
            HeaderView(viewModel: viewModel)
            
            // Modern Calendar View
            CalendarView(viewModel: viewModel)
            
            // Mood Legend
            MoodLegendView()
        }
        .padding(.top, 20)
        .animation(.easeInOut, value: viewModel.selectedDate)
    }
}

// MARK: - HeaderView
struct HeaderView: View {
    @Bindable var viewModel: SavedMoodViewModel
    
    var body: some View {
        HStack {
            Button {
                if let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: viewModel.selectedDate) {
                    viewModel.selectedDate = previousMonth
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            Text(viewModel.selectedDate, format: .dateTime.month(.wide).year())
                .font(.title2)
                .fontWeight(.semibold)
            
            Spacer()
            
            Button {
                if let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: viewModel.selectedDate) {
                    viewModel.selectedDate = nextMonth
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - CalendarView
struct CalendarView: View {
    @Bindable var viewModel: SavedMoodViewModel
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        VStack(spacing: 20) {
            // Days of the Week
            HStack(spacing: 0) {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 10)
            
            // Days of the Month
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(viewModel.monthDays, id: \.self) { date in
                    CalendarDayView(date: date, viewModel: viewModel)
                }
            }
            .padding(.horizontal, 10)
        }
        .padding(.vertical, 20)
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal, 20)
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -50 {
                        // Swipe left: Go to next month
                        if let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: viewModel.selectedDate) {
                            viewModel.selectedDate = nextMonth
                        }
                    } else if value.translation.width > 50 {
                        // Swipe right: Go to previous month
                        if let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: viewModel.selectedDate) {
                            viewModel.selectedDate = previousMonth
                        }
                    }
                }
        )
    }
}

// MARK: - CalendarDayView
struct CalendarDayView: View {
    let date: Date
    @Bindable var viewModel: SavedMoodViewModel
    
    var body: some View {
        let moodForDay = viewModel.moodForDay(date: date)
        let isToday = Calendar.current.isDateInToday(date)
        
        VStack(spacing: 4) {
            // Day Number
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.system(size: 16, weight: isToday ? .bold : .regular))
                .foregroundColor(isToday ? .white : .primary)
                .frame(width: 30, height: 30)
                .background(isToday ? Color.blue : Color.clear)
                .clipShape(Circle())
            
            // Mood Text (only show if mood is not unknown)
            if let mood = moodForDay, mood != .unknown {
                Text(Mood(mood.rawValue))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1) // Ensure text stays in one line
                    .minimumScaleFactor(0.5) // Shrink text if it doesn't fit
                    .fixedSize(horizontal: false, vertical: true) // Prevent wrapping
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.blue.opacity(isToday ? 1 : 0), lineWidth: 1)
        )
        .onTapGesture {
            // Handle date selection
            viewModel.selectedDate = date
        }
    }
}

// MARK: - MoodLegendView
struct MoodLegendView: View {
    var body: some View {
        HStack(spacing: 20) {
            ForEach(Mood.allCases, id: \.self) { mood in
                HStack(spacing: 6) {
                    Circle()
                        .fill(mood.color)
                        .frame(width: 10, height: 10)
                    Text(mood.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    MoodHistoryView(viewModel: SavedMoodViewModel(context: try! ModelContainer(for: SavedMood.self).mainContext))
}
