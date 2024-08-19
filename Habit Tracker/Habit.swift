//
//  Habit.swift
//  Habit Tracker
//
//  Created by Thibault Giraudon on 10/08/2024.
//

import SwiftUI

struct Habit: Identifiable, Hashable, Codable {
    let id = UUID()
    var name: String
    var type: HabitType
    var achieved: Bool
    var value: Double {
        didSet {
            if value >= goal {
                achieved = true
            } else {
                achieved = false
            }
        }
    }
    var unit: String
    var goal: Double
    var color: Color
    var icon: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case type
        case achieved
        case value
        case unit
        case goal
        case color
        case icon
    }
    
    init(name: String, type: HabitType, achieved: Bool, value: Double, goal: Double, color: Color, icon: String) {
        self.name = name
        self.type = type
        self.achieved = achieved
        self.value = value
        self.goal = goal
        self.color = color
        self.icon = icon
        self.unit = "minutes"
    }
    
    init() {
        self.name = ""
        self.type = .toggle
        self.achieved = false
        self.value = 0.0
        self.goal = 1.0
        self.color = .blue
        self.icon = "dumbbell"
        self.unit = "min"
    }
}

enum HabitType: String, Codable {
    case slider, toggle, stepper
}
