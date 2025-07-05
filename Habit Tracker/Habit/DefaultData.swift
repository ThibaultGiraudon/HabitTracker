//
//  DefaultData.swift
//  Habit Tracker
//
//  Created by Thibault Giraudon on 05/07/2025.
//

import Foundation

class DefaultData {
    
    func generateDay(for index: Int) -> [Day] {
        let habits: [Habit] = [
            Habit(name: "Run", type: .slider, achieved: true, value: 30, goal: 30, color: .green, icon: "figure.run"),
            Habit(name: "Read", type: .stepper, achieved: true, value: 10, goal: 10, color: .blue, icon: "book.fill"),
            Habit(name: "Make bed", type: .toggle, achieved: true, value: 0, goal: 1, color: .red, icon: "bed.double")
        ]
        
        var days: [Day] = []
        
        for i in 0..<(index) {
            days.append(Day(date: Date().addingTimeInterval(-TimeInterval(86400 * i)), habits: habits))
        }
        
        return days
    }
    
}
