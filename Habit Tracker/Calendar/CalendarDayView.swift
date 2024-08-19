//
//  CalendarDayView.swift
//  Habit Tracker
//
//  Created by Thibault Giraudon on 07/08/2024.
//

import SwiftUI

struct CalendarDayView: View {
    let date: Date
    let habitResult: Double
    let habits: [Habit]
    let calendar = Calendar.current
    var body: some View {
        VStack {
            Text("\(calendar.component(.day, from: date))")
                .font(.headline)
                .foregroundStyle(Color("TextColor"))
            if date > Date() || habits.isEmpty {
                Circle()
                    .fill(Color.clear)
                    .frame(width: 20, height: 20)
            }
            else if habitResult == 100.0 {
                Circle()
                    .fill(Color.green)
                    .frame(width: 20, height: 20)
            }
            else if habitResult >= 75 {
                Circle()
                    .fill(Color.yellow)
                    .frame(width: 20, height: 20)
            }
            else if habitResult >= 50 {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 20, height: 20)
            }
            else if habitResult < 0 {
                Circle()
                    .fill(Color.clear)
                    .frame(width: 20, height: 20)
            }
            else {
                Circle()
                    .fill(Color.red)
                    .frame(width: 20, height: 20)
            }
        }
    }
}

#Preview {
    CalendarDayView(date: Date(), habitResult: 69.0, habits: [])
}
