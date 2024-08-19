//
//  CustomSlider.swift
//  Habit Tracker
//
//  Created by Thibault Giraudon on 11/08/2024.
//

import SwiftUI

struct CustomSlider: View {
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
        .gesture(
            DragGesture()
                .onChanged { value in
                    size = max(0, initialSize + value.translation.width)
                    habit.value = Double(size) / Double(UIScreen.main.bounds.width - 50) * habit.goal
                    if size > UIScreen.main.bounds.width {
                        size = UIScreen.main.bounds.width /*- 50*/
                        habit.value = habit.goal
                    }
                    user.setValue(habit.value, for: habit, date: date)
                }
                .onEnded { _ in
                    initialSize = size
                }
        )
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
        @State var habit = Habit(name: "Running", type: .slider, achieved: false, value: 50.0, goal: 130.0, color: .green, icon: "figure.run")
        var body: some View {
            CustomSlider(user: User(), habit: $habit, date: Date())
        }
    }
    
    return Preview()
}
