//
//  Day.swift
//  Habit Tracker
//
//  Created by Thibault Giraudon on 10/08/2024.
//

import SwiftUI

struct Day: Identifiable, Hashable, Codable {
    let id = UUID()
    var date: Date = Date()
//    var habits: [Habit] = [
//        Habit(name: "Make bed", type: .toggle, achieved: true, value: 0.0, goal: 1.0, color: .green, icon: "bed.double.fill"),
//        Habit(name: "Run", type: .slider, achieved: false, value: 10.0, goal: 130.0, color: .purple, icon: "figure.run"),
//        Habit(name: "Drink", type: .stepper, achieved: false, value: 0.0, goal: 21.0, color: .blue, icon: "waterbottle"),
//    ]
    var habits: [Habit] = []
    var habitsAchieved: Int {
        habits.filter({$0.achieved}).count
    }
    var habitsAdvancement: Double {
        var advancement = 0.0
        for habit in habits {
            if habit.type == .toggle {
                advancement += habit.achieved ? 1.0 : 0.0
            }
            else {
                advancement += habit.value / habit.goal
            }
        }
        if habits.isEmpty {
            return 0.0
        }
        return advancement / Double(habits.count) * 100
    }
    
    init(date: Date, habits: [Habit]) {
        self.date = date
        self.habits = habits
    }
    
    enum CodingKeys: String, CodingKey {
        case date
        case habits
    }
    
}
