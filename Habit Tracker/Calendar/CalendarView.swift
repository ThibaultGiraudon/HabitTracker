//
//  CalendarView.swift
//  Habit Tracker
//
//  Created by Thibault Giraudon on 07/08/2024.
//

import SwiftUI

extension Date {
    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date! + 86400
    }
    
}

struct CalendarView: View {
    @ObservedObject var user = User()
    let calendar = Calendar.current
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_EN")
        formatter.dateFormat = "LLLL yyyy"
        return formatter
    }()
    @State private var showSheet = false
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("Calendar")
                    .font(.largeTitle.bold())
                Text("See your past progression")
            }
            .foregroundStyle(Color("OffWhite"))
            .environment(\.colorScheme, .light)
            .padding(.horizontal)
            ZStack {
                RoundedRectangle(cornerRadius: 45)
                    .fill(Color("OffWhite"))
                    .ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(generateMonthsUpToCurrentDate(), id: \.self) { month in
                            VStack {
                                HStack {
                                    Spacer()
                                    Text("\(dateFormatter.string(from: month))")
                                        .font(.title.bold())
                                        .foregroundStyle(Color("TextColor"))
                                    Spacer()
                                }
                                let days = generateDaysInMonth(for: month)
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                                    ForEach(days, id: \.self) { date in
                                        CalendarDayView(date: date, habitResult: user.getAdvancement(for: date), habits: user.getDay(for: date).habits)
                                            .onTapGesture {
                                                if date <= Date() && !user.getDay(for: date).habits.isEmpty {
                                                    showSheet = true
                                                    selectedDate = date
                                                }
                                            }
                                    }
                                }
                            }
                        }
                        .sheet(isPresented: $showSheet) {
                            DetailView(date: selectedDate, user: user)
                                .presentationDragIndicator(.visible)
                        }
                    }
                    .padding(.top)
                    Spacer()
                        .frame(height: UIScreen.main.bounds.height / 16)
                }
                .ignoresSafeArea()
                .clipShape(
                    RoundedRectangle(cornerRadius: 45)
                )
                .defaultScrollAnchor(generateMonthsUpToCurrentDate().count > 2 ? .bottom : .top)
            }
        }
        .background(Color("DimGray"))
    }
    
    // Générez les jours pour un mois donné
    func generateDaysInMonth(for date: Date) -> [Date] {
        var days: [Date] = []
        guard let monthInterval = calendar.dateInterval(of: .month, for: date) else { return days }
        
        var currentDate = monthInterval.start
        while currentDate < monthInterval.end {
            days.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return days
    }
    
    // Générez tous les mois jusqu'à la date actuelle
    func generateMonthsUpToCurrentDate() -> [Date] {
        var months: [Date] = []
        let currentDate = Date()
        var startDate = user.days.sorted(by: { $0.date < $1.date }).first?.date ?? Date()
        months.append(startDate)
        
        while Calendar.current.component(.month, from: startDate) < Calendar.current.component(.month, from: currentDate) {
            startDate = calendar.date(byAdding: .month, value: 1, to: startDate) ?? startDate
            months.append(startDate)
        }
        
        return months
    }
}

#Preview {
    CalendarView()
}

