//
//  MainView.swift
//  Mood Tracker
//
//  Created by FayTek on 1/3/25.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel: SavedMoodViewModel
    
    init() {
        // Initialize the ViewModel with a placeholder context
        // The actual context will be injected in `onAppear`
        self._viewModel = StateObject(wrappedValue: SavedMoodViewModel(context: nil))
    }
    
    var body: some View {
        TabView {
            MoodSelectionScreen(viewModel: viewModel)
                .tabItem {
                    Label("Mood Selection", systemImage: "square.and.pencil")
                }
            
            MoodHistoryView(viewModel: viewModel)
                .tabItem {
                    Label("Mood History", systemImage: "list.dash")
                }
        }
        .tint(Color.black)
        .onAppear {
            // Inject the context into the ViewModel
            viewModel.context = context
            viewModel.fetch()
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: SavedMood.self)
}
