//
//  MainView.swift
//  Mood Tracker
//
//  Created by FayTek on 1/3/25.
//

import Foundation
import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var context
    @State var viewModel: SavedMoodViewModel
    
    init() {
        self.viewModel = SavedMoodViewModel()
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
        onAppear {
            viewModel = SavedMoodViewModel(context: context)
        }
    }
}

#Preview {
    MainView()
}
