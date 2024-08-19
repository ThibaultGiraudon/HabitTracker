//
//  User.swift
//  Habit Tracker
//
//  Created by Thibault Giraudon on 10/08/2024.
//

import SwiftUI

class User: ObservableObject {
    let id = UUID()
    @Published var days: [Day] = []
    @Published var weekdays: [[Habit]] = Array(repeating: [], count: 7)
    @Published var currentStreak: Int = 0
    @Published var longestStreak: Int = 0
    @Published var completionRate: Int = 0
    @Published var bestMonth: String = "--"
    
    init() {
        // Décode le tableau de tableaux de Habit
        if let savedWeek = UserDefaults.standard.data(forKey: "weekdays"),
           let decodedWeek = try? JSONDecoder().decode([[Habit]].self, from: savedWeek) {
            self.weekdays = decodedWeek
        } else {
            self.weekdays = Array(repeating: [], count: 7) // Valeur par défaut : 7 tableaux vides
        }
        if let savedDays = UserDefaults.standard.data(forKey: "days"),
           let decodedDays = try? JSONDecoder().decode([Day].self, from: savedDays) {
            self.days = decodedDays
        } else {
            self.days = [
                Day(date: Date(), habits: [Habit(name: "test", type: .slider, achieved: false, value: 19, goal: 21, color: .blue, icon: "chevron.left.circle.fill")]),
                 Day(date: Date() - (86400 * 30), habits: [Habit(name: "test", type: .slider, achieved: false, value: 19, goal: 21, color: .blue, icon: "chevron.left.circle.fill")]),
                 Day(date: Date() - (86400 * 60), habits: [Habit(name: "test", type: .slider, achieved: false, value: 18, goal: 21, color: .blue, icon: "chevron.left.circle.fill")]),
                 Day(date: Date() - (86400 * 90), habits: [Habit(name: "test", type: .slider, achieved: true, value: 21, goal: 21, color: .blue, icon: "chevron.left.circle.fill")]),
                         ]
        }
        self.loadHighlights()
    }
    
    func loadHighlights() {
        if days.isEmpty {
            return
        }
        var streak = 0
        var breakStreak: Bool = false
        if !days.isEmpty {
            for day in days.sorted(by: { $0.date > $1.date }) {
                if day.habitsAdvancement == 100 && breakStreak == false {
                    streak += 1
                }
                else {
                    breakStreak = true
                }
            }
        }
        self.currentStreak = streak
        
        streak = 0
        
        var maxStreak = 0
        for day in days.sorted(by: { $0.date < $1.date }) {
            if day.habitsAdvancement == 100 {
                streak += 1
            }
            else {
                if streak > maxStreak {
                    maxStreak = streak
                }
                streak = 0
            }
        }
        self.longestStreak = maxStreak < streak ? streak : maxStreak
        
        if days.count == 0 {
            self.completionRate = 0
        } else {
            var completionTotal: Int = 0
            for day in days {
                completionTotal += Int(day.habitsAdvancement)
            }
            
            self.completionRate = Int(completionTotal / days.count)
        }
        
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_EN")
            formatter.dateFormat = "LLL yy"
            return formatter
        }()
        
        var numberOfDay: Int = 0
        var pastDate: Date = days.sorted(by: { $0.date > $1.date })[0].date
        var totalAchievements: Int = 0
        var bestAchievement: Int = 0
        for day in days.sorted(by: { $0.date > $1.date }) {
            if Calendar.current.component(.month, from: pastDate) != Calendar.current.component(.month, from: day.date) {
                if bestAchievement < totalAchievements / numberOfDay {
                    bestAchievement = totalAchievements / numberOfDay
                    bestMonth = String(dateFormatter.string(from: pastDate))
                    if bestAchievement == 100 {
                        break
                    }
                }
                numberOfDay = 0
                totalAchievements = 0
            }
            pastDate = day.date
            numberOfDay += 1
            totalAchievements += Int(day.habitsAdvancement)
            if day == days.sorted(by: { $0.date > $1.date }).last! {
                if bestAchievement < totalAchievements / numberOfDay {
                    bestAchievement = totalAchievements / numberOfDay
                    bestMonth = String(dateFormatter.string(from: day.date))
                }
            }
        }
        
    }
    
    func save() {
        // Encode le tableau de tableaux de Habit
        if let encodedWeek = try? JSONEncoder().encode(self.weekdays) {
            UserDefaults.standard.set(encodedWeek, forKey: "weekdays")
        }
        if let encodedDay = try? JSONEncoder().encode(self.days) {
            UserDefaults.standard.set(encodedDay, forKey: "days")
        }
    }
    
    func createDay(_ date: Date) -> Day {
        switch Calendar.current.component(.weekday, from: date) {
            case 2:
                let day = Day(date: date, habits: weekdays[0])
                days.append(day)
                return day
            case 3:
                let day = Day(date: date, habits: weekdays[1])
                days.append(day)
                return day
            case 4:
                let day = Day(date: date, habits: weekdays[2])
                days.append(day)
                return day
            case 5:
                let day = Day(date: date, habits: weekdays[3])
                days.append(day)
                return day
            case 6:
                let day = Day(date: date, habits: weekdays[4])
                days.append(day)
                return day
            case 7:
                let day = Day(date: date, habits: weekdays[5])
                days.append(day)
                return day
            default:
                let day = Day(date: date, habits: weekdays[6])
                days.append(day)
                return day
        }
    }
    
    func getDay(for date: Date) -> Day {
        return days.first(where: { $0.date.stripTime() == date.stripTime() }) ?? createDay(date)
    }
    
    func setValue(_ value: Double, for habit: Habit, date: Date) {
        if let index = days.firstIndex(where: { $0.date.stripTime() == date.stripTime() }) {
            if let habitIndex = days[index].habits.firstIndex(where: { $0.id == habit.id }) {
                days[index].habits[habitIndex].value = value
                self.save()
            }
        }
    }
    
    func setAchieved(_ achieved: Bool, for habit: Habit, date: Date) {
        if let index = days.firstIndex(where: { $0.date.stripTime() == date.stripTime() }) {
            if let habitIndex = days[index].habits.firstIndex(where: { $0.id == habit.id }) {
                days[index].habits[habitIndex].achieved = achieved
                self.save()
            }
        }
    }
    
    func removeHabit(_ habit: Habit) {
        if let dayIndex = days.firstIndex(where: { $0.date.stripTime() == Date().stripTime( )}) {
            if let habitIndex = days[dayIndex].habits.firstIndex(where: { $0.id.uuidString == habit.id.uuidString }) {
                days[dayIndex].habits.remove(at: habitIndex)
            }
        }
        // get habit thanks to offsets
        
        
        switch Calendar.current.component(.weekday, from: Date()) {
            case 2:
                if let index = weekdays[0].firstIndex(where: { $0.id.uuidString == habit.id.uuidString }) {
                    weekdays[0].remove(at: index)
                }

            case 3:
                if let index = weekdays[1].firstIndex(where: { $0.id.uuidString == habit.id.uuidString }) {
                    weekdays[1].remove(at: index)
                }

            case 4:
                if let index = weekdays[2].firstIndex(where: { $0.id.uuidString == habit.id.uuidString }) {
                    weekdays[2].remove(at: index)
                }

            case 5:
                if let index = weekdays[3].firstIndex(where: { $0.id.uuidString == habit.id.uuidString }) {
                    weekdays[3].remove(at: index)
                }

            case 6:
                if let index = weekdays[4].firstIndex(where: { $0.id.uuidString == habit.id.uuidString }) {
                    weekdays[4].remove(at: index)
                }

            case 7:
                if let index = weekdays[5].firstIndex(where: { $0.id.uuidString == habit.id.uuidString }) {
                    weekdays[5].remove(at: index)
                }

            default:
                if let index = weekdays[6].firstIndex(where: { $0.id.uuidString == habit.id.uuidString }) {
                    weekdays[6].remove(at: index)
                }
        }
        self.save()
    }
    
    func addHabit(_ habit: Habit, to selectedDays: [Int]) {
        
        for weekday in selectedDays {
            let selectedDate = Calendar.current.date(byAdding: .day, value: weekday -
                                (Calendar.current.component(.weekday, from: Date()) + 5) % 7, to: Date())!
            if let index = days.firstIndex(where: { $0.date.stripTime() == selectedDate.stripTime() }) {
                days[index].habits.append(habit)
                self.save()
            } else {
                var newDay = Day(date: Date(), habits: [])
                newDay.habits.append(habit)
                days.append(newDay)
                self.save()
            }
            self.weekdays[weekday].append(habit)
        }
    }
    
    func result(for date: Date) -> Day? {
        days.first(where: { $0.date.stripTime() == date.stripTime() })
    }
    
    func getAdvancement(for date: Date) -> Double {
        let day = days.first(where: { $0.date.stripTime() == date.stripTime() })
        return day?.habitsAdvancement ?? 0.0
    }
}
