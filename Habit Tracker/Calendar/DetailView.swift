//
//  DetailView.swift
//  Habit Tracker
//
//  Created by Thibault Giraudon on 10/08/2024.
//

import SwiftUI

struct DetailView: View {
    var date: Date
    var user: User
    var day: Day? {
        user.result(for: date)
    }
    var body: some View {
        if let day = day {
            VStack {
                Text("\(day.date, format: .dateTime.day().month().year())")
                    .font(.title)
                    .padding()
                    .foregroundStyle(Color("TextColor"))
                ScrollView {
                    ForEach(day.habits.sorted(by: { !$0.achieved && $1.achieved }), id: \.id) { habit in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(habit.color)
                                .frame(width: UIScreen.main.bounds.width - 50, height: 70)
                                .opacity(0.5)
                            Rectangle()
                                .fill(habit.color)
                                .opacity(habit.achieved ? 0.5 : 1)
                                .frame(width: habit.value / habit.goal * (UIScreen.main.bounds.width - 50), height: 70)
                                HStack {
                                    Image(systemName: habit.icon)
                                        .font(.title.bold())
                                        .padding()
                                        .opacity(habit.achieved ? 0.5 : 1)
                                    Text(habit.name)
                                        .font(.title)
                                        .strikethrough(habit.achieved, color: Color("OffWhite"))
                                        .opacity(habit.achieved ? 0.5 : 1)
                                    Spacer()
                                    if habit.achieved {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.title.bold())
                                            .padding()
                                    } else {
                                        Text("\(Int(habit.value)) / \(Int(habit.goal))")
                                            .foregroundStyle(Color("OffWhite"))
                                            .padding()
                                    }
                                }
                                .foregroundStyle(Color("OffWhite"))
                                .environment(\.colorScheme, .light)
                                .frame(width: UIScreen.main.bounds.width - 50)
                            }
                            .clipShape(
                                RoundedRectangle(cornerRadius: 10)
                            )
                            .padding(25)
                    }
                }
            }
            .background(Color("OffWhite"))
        }
    }
}

#Preview {
    DetailView(date: Date(), user: User())
}
