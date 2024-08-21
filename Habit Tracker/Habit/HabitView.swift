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
    @State private var days: [Int] = Array(0..<7)
    private var currentHabit: Habit?
    let weekdays: [String] = ["MO", "TU", "WE", "TH", "FR", "SA", "SU"]
    
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
                    VStack {
                        Text("\(weekdays[index])")
                            .bold()
                            .foregroundColor(Color("OffWhite"))
                            .environment(\.colorScheme, .light)
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text("\(days[index])")
                            .bold()
                            .foregroundColor(Color("DimGray"))
                            .padding(10)
                            .background(Color("OffWhite"))
                            .clipShape(Circle())
                            .environment(\.colorScheme, .light)
                    }
                    .padding(.vertical, 5)
                    .background {
                        if index == (Calendar.current.component(.weekday, from: selectedDay.date) + 5) % 7 {
                            Capsule()
                                .fill(.blue)
                        } else if index == (Calendar.current.component(.weekday, from: Date()) + 5) % 7 {
                            Capsule()
                                .stroke(Color.blue, lineWidth: 5)
                        }
                    }
                    .clipShape(Capsule())
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
            days = getWeekDays()
        }
    }
    
    func getWeekDays() -> [Int] {
        var days: [Int] = []
        guard let weekInterval = Calendar.current.dateInterval(of: .weekOfYear, for: Date()) else { return [] }
        
        var currentDate = weekInterval.start
        while currentDate < weekInterval.end {
            days.append(Calendar.current.component(.day, from: currentDate))
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return days
    }
    
}

#Preview {
    NavigationStack {
        HabitView(user: User())
    }
}
