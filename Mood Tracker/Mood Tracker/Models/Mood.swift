//
//  Mood.swift
//  Mood Tracker
//
//  Created by FayTek on 1/3/25.
//

import Foundation
import SwiftUI

enum Mood: String, CaseIterable, Codable {
    case veryUnpleasant = "Very Unpleasant"
    case unpleasant = "Unpleasant"
    case neutral = "Neutral"
    case pleasant = "Pleasant"
    case veryPleasant = "Very Pleasant"
    case unknown = "Unknown"
    
    var color: Color {
        switch self {
        case .veryUnpleasant: return .red
        case .unpleasant: return .orange
        case .neutral: return .yellow
        case .pleasant: return .green
        case .veryPleasant: return .blue
        case .unknown: return .gray
        }
    }
}
