//
//  Tab.swift
//  Habit Tracker
//
//  Created by Thibault Giraudon on 10/08/2024.
//

import SwiftUI

enum Tab: String, CaseIterable, Identifiable {
    case calendar = "calendar"
    case habits = "house"
    case stats = "chart.line.uptrend.xyaxis"
    
    var id: String {
        self.rawValue
    }
}
