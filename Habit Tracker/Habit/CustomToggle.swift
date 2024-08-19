//
//  CustomToggle.swift
//  Habit Tracker
//
//  Created by Thibault Giraudon on 11/08/2024.
//

import SwiftUI

struct CustomToggle: View {
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
            habit.achieved.toggle()
            user.setAchieved(habit.achieved, for: habit, date: date)
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 10)
                .size(CGSize(width: UIScreen.main.bounds.width - 50, height: 70))
        )
        .padding()
        .onAppear {
            size = (habit.value / habit.goal) * UIScreen.main.bounds.width
            initialSize = size
        }
    }
}

#Preview {
    struct Preview: View {
        @State var habit = Habit(name: "Make bed", type: .toggle, achieved: false, value: 0.0, goal: 1.0, color: .purple, icon: "bed.double")
        var body: some View {
            CustomToggle(user: User(), habit: $habit, date: Date())
        }
    }
    
    return Preview()
}
