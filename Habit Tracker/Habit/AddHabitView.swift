//
//  AddHabitView.swift
//  Habit Tracker
//
//  Created by Thibault Giraudon on 30/07/2024.
//

import SwiftUI

enum Unit: String, CaseIterable, Identifiable {
    case km
    case miles
    case min
    case hours
    case glasses
    
    var id: String { return self.rawValue }
}

struct AddHabitView: View {
    var user: User
    let columns = Array(repeating: GridItem(.flexible()), count: 5)
    @Environment(\.dismiss) var dismiss
    @FocusState var searchFocus: Bool
    @State private var habit: Habit = Habit()
    @State private var selectedType: HabitType = .slider
    @State private var searchText: String = ""
    @State private var selectedWeekdays: [Int] = [Calendar.current.component(.weekday, from: Date()) - 2]
    let types: [HabitType] = [.slider, .toggle, .stepper]
    let weekdays: [String] = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"]
    var filteredSymbols: [String] {
        return searchText.isEmpty ? symbols : symbols.filter { $0.lowercased().contains(searchText.lowercased()) }
    }
    var body: some View {
        VStack {
            Form {
                Section("Select type") {
                    Picker("\(habit.type)", selection: $habit.type) {
                        ForEach(types, id: \.self) { type in
                            Text("\(type)")
                        }
                    }
                }
                
                Section("Configure habit") {
                    TextField("Habit name", text: $habit.name)
                    ScrollView {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Search", text: $searchText)
                                .focused($searchFocus)
                            if !searchText.isEmpty {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .onTapGesture {
                                        searchText = ""
                                        searchFocus = false
                                    }
                            }
                        }
                        LazyVGrid(columns: columns, spacing: 5) {
                            ForEach(filteredSymbols, id: \.self) { icon in
                                Image(systemName: icon)
                                    .font(.title)
                                    .foregroundStyle(icon == habit.icon ? habit.color : Color("TextColor"))
                                    .onTapGesture {
                                        habit.icon = icon
                                        searchFocus = false
                                    }
                            }
                        }
                    }
                    .frame(height: UIScreen.main.bounds.height / 5)
                    ColorPicker("Select color", selection: $habit.color)
                    HStack {
                        ForEach(0..<7) { i in
                            Text("\(weekdays[i])")
                                .padding(.vertical, 7)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .background(selectedWeekdays.contains(i) ? habit.color : Color.clear)
                                .onTapGesture {
                                    if let index = selectedWeekdays.firstIndex(of: i) {
                                        selectedWeekdays.remove(at: index)
                                    } else {
                                        selectedWeekdays.append(i)
                                    }
                                }
                                .clipShape(Capsule())
                        }
                    }
                }
                
                if habit.type != .toggle {
                    Section("Goal") {
                        TextField("Goal", value: $habit.goal, format: .number)
                            .keyboardType(.numberPad)
                    }
                }
                
            }
            Section("Preview") {
                switch habit.type {
                case .slider:
                    CustomSlider(user: user, habit: $habit, date: Date())
                case .toggle:
                    CustomToggle(user: user, habit: $habit, date: Date())
                case .stepper:
                    CustomStepper(user: user, habit: $habit, date: Date())
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    habit.value = 0.0
                    user.addHabit(habit, to: selectedWeekdays)
                    dismiss()
                }
                .disabled(habit.name.isEmpty || habit.goal == 0.0 || selectedWeekdays.isEmpty)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
}

var habits: [Habit] = []

func save(_ habit: Habit) {
    habits.append(habit)
}

#Preview {
    
    NavigationStack {
        AddHabitView(user: User())
    }
}
