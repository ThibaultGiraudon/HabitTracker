//
//  ContentView.swift
//  Habit Tracker
//
//  Created by Thibault Giraudon on 30/07/2024.
//

import SwiftUI

struct HabitView: View {
    @Namespace private var animation
    @ObservedObject var user: User
    @State private var selectedDay: Day = Day(date: Date(), habits: [])
    let currentWeekday: Int = Calendar.current.component(.weekday, from: Date())
    @State private var showingAddHabitSheet = false
    @State private var showingAlert = false
    @State private var habitDoneCount = 0
    @State private var animationAmount: CGFloat = 0
    @State private var selectedDate = Date()
    private var currentHabit: Habit?
    let weekdays: [String] = ["M", "T", "W", "T", "F", "S", "S"]
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_EN")
        formatter.dateFormat = "LLLL, yyyy"
        return formatter
    }()
    
    let dimGray = Color("DimGray")
    
    init(user: User) {
        self._user = ObservedObject(initialValue: user)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("Habits")
                    .font(.largeTitle.bold())
                Text("\(dateFormatter.string(from: selectedDay.date))")
            }
            .foregroundColor(Color("OffWhite"))
            .environment(\.colorScheme, .light)
            .padding(.horizontal)
            HStack {
                ForEach(0..<7, id: \.self) { index in
                    Text("\(weekdays[index])")
                        .foregroundColor(Color("OffWhite"))
                        .environment(\.colorScheme, .light)
                        .font(.title.bold())
                        .frame(width: 40, height: 40)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background {
                            if index == (Calendar.current.component(.weekday, from: selectedDay.date) + 5) % 7 {
                                Circle()
                                    .fill(.blue)
                            } else if index == (Calendar.current.component(.weekday, from: Date()) + 5) % 7 {
                                Circle()
                                    .stroke(Color.blue, lineWidth: 5)
                            }
                        }
                        .clipShape(Circle())
                        .onTapGesture {
                            selectedDate = Calendar.current.date(byAdding: .day, value: index - (Calendar.current.component(.weekday, from: Date()) + 5) % 7, to: Date())!
                            selectedDay = user.getDay(for: selectedDate)
                        }
                }
            }
            ZStack {
                RoundedRectangle(cornerRadius: 35)
                    .fill(Color("OffWhite"))
                    .ignoresSafeArea()
            if selectedDay.habits.isEmpty {
                ContentUnavailableView(
                    "No habits yet",
                    systemImage: "list.bullet",
                    description: Text("Tap the '+' button to create a habit")
                )
                .foregroundStyle(Color("TextColor"))
            }
            else {
                    VStack {
                        HStack {
                            Text("Habits list")
                                .foregroundStyle(Color("TextColor"))
                                .font(.title2.bold())
                                .foregroundStyle(dimGray)
                            Spacer()
                        }
                        .padding([.top, .leading], 30)
                        ScrollView {
                            ForEach($selectedDay.habits.sorted(by: { !$0.achieved.wrappedValue && $1.achieved.wrappedValue }), id: \.id) { $habit in
                                switch habit.type {
                                case .slider:
                                    CustomSlider(user: user, habit: $habit, date: selectedDay.date)
                                        .disabled(selectedDay.date.stripTime() != Date().stripTime())
                                case .toggle:
                                    CustomToggle(user: user, habit: $habit, date: selectedDay.date)
                                        .disabled(selectedDay.date.stripTime() != Date().stripTime())
                                case .stepper:
                                    CustomStepper(user: user, habit: $habit, date: selectedDay.date)
                                        .disabled(selectedDay.date.stripTime() != Date().stripTime())
                                }
                            }
                            .onMove(perform: moveHabit)
                            .onChange(of: user.getDay(for: Date())) {
                                selectedDay = user.getDay(for: selectedDate)
                            }
                        }
                        .listStyle(.plain)
                    }
                }
            }
        }
        .background(dimGray)
        .sheet(isPresented: $showingAddHabitSheet) {
            NavigationStack {
                AddHabitView(user: user)
                    .presentationDragIndicator(.visible)
            }
        }
        .onAppear {
            selectedDay = user.getDay(for: Date())
        }
    }
    
    private func moveHabit(from source: IndexSet, to destination: Int) {
        selectedDay.habits.move(fromOffsets: source, toOffset: destination)
    }
    
    private func deleteHabit(at offsets: IndexSet) {
        selectedDay.habits.remove(atOffsets: offsets)
    }
    
}

#Preview {
    NavigationStack {
        HabitView(user: User())
    }
}
