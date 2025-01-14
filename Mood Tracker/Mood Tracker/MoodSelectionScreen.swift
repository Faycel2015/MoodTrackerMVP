//
//  ContentView.swift
//  Mood Tracker
//
//  Created by FayTek on 1/2/25.
//

import Foundation
import SwiftUI
import SwiftData

struct MoodSelectionScreen: View {
    var viewModel = SavedMoodViewModel()
    
    init(viewModel: SavedMoodViewModel = SavedMoodViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            viewModel.selectedMood.color
                .edgesIgnoringSafeArea(.all)
                .opacity(0.2)
            
            VStack {
                Text("How are you feeling today?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                // Blob
                BlobView(color: viewModel.selectedMood.color)
                    .onTapGesture {
                        viewModel.fetch()
                    }
                
                Spacer()
                
                Text(viewModel.selectedMood.rawValue)
                    .font(.title)
                
                Spacer()
                
                MoodSlider(viewModel: viewModel)
                
                Spacer()
                
                Button {
                    // Save the mood
                    viewModel.save(mood: viewModel.selectedMood, date: Date())
                } label: {
                    Text("Save")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.selectedMood.color)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            }
            .padding(40)
        }
    }
}

struct BlobView: View {
    var color: Color
    
    var body: some View {
        Circle()
            .foregroundStyle(color)
            .frame(width: 200, height: 200)
    }
}

struct MoodSlider: View {
    var viewModel: SavedMoodViewModel
    private var size: CGFloat = 40
    private let trackWidth: CGFloat = 300
    @State private var xValue: CGFloat = 0
    private let steps = 5
    
    // Public initializer
       init(viewModel: SavedMoodViewModel) {
           self.viewModel = viewModel
           // Initialize xValue based on the initial moodValue
           self._xValue = State(initialValue: CGFloat(viewModel.moodValue) * (trackWidth - size) / CGFloat(steps - 1))
       }
    
    var body: some View {
        let stepWidth = (trackWidth - size) / CGFloat(steps - 1)
        
        ZStack(alignment: .leading) {
            Capsule()
                .frame(width: trackWidth, height: size)
                .opacity(0.2)
                .foregroundStyle(Color.gray)
            
            Circle()
                .frame(width: size, height: size)
                .offset(x: xValue)
                .foregroundColor(Color.white)
                .shadow(radius: 10)
                .gesture(DragGesture().onChanged { value in
                    viewModel.updateMoodValue(sliderXValue: value.location.x,
                                              stepWidth: stepWidth,
                                              size: size,
                                              trackWidth: trackWidth)
                    xValue = CGFloat(viewModel.moodValue) * stepWidth
                })
        }
    }
}

#Preview {
    MoodSelectionScreen(viewModel: SavedMoodViewModel())
}
