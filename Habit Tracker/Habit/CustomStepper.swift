//
//  CustomStepper.swift
//  Habit Tracker
//
//  Created by Thibault Giraudon on 11/08/2024.
//

import SwiftUI

struct CustomStepper: View {
    @ObservedObject var user: User
    @Binding var habit: Habit
    let date: Date
    @State private var initialSize: CGFloat = 300
    @State private var size: CGFloat = 300
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(habit.color.opacity(0.5))
                .frame(width: UIScreen.main.bounds.width - 50, height: 70)
            Rectangle()
                .fill(habit.color)
                .frame(width: size, height: 70)
                .opacity(habit.achieved ? 0.5 : 1.0)
            
            HStack {
                Image(systemName: habit.icon)
                    .padding()
                    .font(.title.bold())
                    .opacity(habit.achieved ? 0.5 : 1.0)
                
                Text(habit.name)
                    .font(.system(size: 20, design: .default))
                    .strikethrough(habit.achieved, color: Color("OffWhite"))
                    .opacity(habit.achieved ? 0.5 : 1.0)
                
                Spacer()
                if habit.achieved {
                    Image(systemName: "checkmark.circle.fill")
                        .padding()
                        .font(.title.bold())
                } else {
                    Text("\(Int(habit.value)) / \(Int(habit.goal))")
                        .padding()
                }
            }
            .foregroundStyle(Color("OffWhite"))
            .environment(\.colorScheme, .light)
        }
        .frame(width: UIScreen.main.bounds.width - 50, height: 70)
        .contextMenu {
            Button("Delete", systemImage: "trash.fill", role: .destructive) {
                user.removeHabit(habit)
            }
        }
        .onTapGesture { location in
            if location.x <= UIScreen.main.bounds.width / 2 {
                if habit.value != 0 {
                    habit.value -= 1
                    size = (habit.value) / habit.goal * (UIScreen.main.bounds.width - 50)
                }
            } else {
                if habit.value < habit.goal {
                    habit.value += 1
                    size = (habit.value) / habit.goal * (UIScreen.main.bounds.width - 50)
                }
            }
            user.setValue(habit.value, for: habit, date: date)
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 10)
                .size(CGSize(width: UIScreen.main.bounds.width - 50, height: 70))
        )
        .onAppear {
            size = (habit.value / habit.goal) * UIScreen.main.bounds.width
            initialSize = size
        }
    }
}

#Preview {
    struct Preview: View {
        @State var habit = Habit(name: "Drink", type: .stepper, achieved: false, value: 13, goal: 21, color: .blue, icon: "waterbottle")
        var body: some View {
            CustomStepper(user: User(), habit: $habit, date: Date())
        }
    }
    
    return Preview()
}
