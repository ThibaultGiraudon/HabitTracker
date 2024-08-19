//
//  StatsView.swift
//  Habit Tracker
//
//  Created by Thibault Giraudon on 12/08/2024.
//

import SwiftUI
import Charts

struct StatsView: View {
    @ObservedObject var user: User
    @State private var date = Date()
    var calendar = Calendar.current
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("Stats")
                    .font(.largeTitle.bold())
                Text("See your habits stats")
                    .font(.subheadline)
            }
            .padding(.horizontal)
            .foregroundStyle(Color("OffWhite"))
            .environment(\.colorScheme, .light)
            ZStack {
                RoundedRectangle(cornerRadius: 45)
                    .fill(Color("OffWhite"))
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Text("Highlights")
                            .foregroundStyle(Color("TextColor"))
                            .font(.title2.bold())
                            .padding(.leading, 15)
                            .padding(.top, 25)
                        Spacer()
                    }
                    
                    LazyVGrid(columns: [.init(), .init()]) {
                        CardView(image: "flame.fill", title: "Current streak", value: "\(user.currentStreak) Days", color: .teal)
                        CardView(image: "checkmark.seal.fill", title: "Longest streak", value: "\(user.longestStreak) Days", color: .pink)
                        CardView(image: "star.fill", title: "Best month", value: "\(user.bestMonth)", color: .purple)
                        CardView(image: "chart.bar.xaxis", title: "Completion rate", value: "\(user.completionRate)%", color: .red)
                    }
                    .padding(.horizontal, 10)
                    
                    HStack {
                        Text("Weekly Performance")
                            .foregroundStyle(Color("TextColor"))
                            .font(.title2.bold())
                            .padding([.top, .leading], 15)
                        Spacer()
                    }
                    
                    Chart {
                        ForEach(generateDaysInWeek(for: date), id: \.self) { day in
                            BarMark(
                                x: .value("Date", day, unit: .day),
                                y: .value("Percent", user.getAdvancement(for: day))
                            )
                            .cornerRadius(8)
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.width < 0 {
                                    if date.stripTime() != Date().stripTime() {
                                        date += 86400 * 7
                                    }
                                } else if value.translation.width > 0 {
                                    date -= 86400 * 7
                                }
                            }
                    )
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day, count: 1)) {
                            AxisValueLabel(format: .dateTime.month().day())
                                .foregroundStyle(Color("TextColor"))
                        }
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading, values: .automatic) {
                            AxisTick()
                                .foregroundStyle(Color("TextColor"))
                            AxisGridLine()
                                .foregroundStyle(Color("TextColor"))
                            AxisValueLabel()
                                .foregroundStyle(Color("TextColor"))
                        }
                    }
                    .chartYScale(domain: 0 ... 100)
                    .frame(height: UIScreen.main.bounds.height / 4)
                    .padding()
                    .foregroundStyle(Color("TextColor"))
                    Spacer()
                }
                //            }
                //            .scrollDisabled(true)
            }
        }
        .background(Color("DimGray"))
    }
    
    func generateDaysInWeek(for date: Date) -> [Date] {
        var days: [Date] = []
        guard let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: date) else { return days }
        
        var currentDate = weekInterval.start
        while currentDate + 86400 < weekInterval.end + 86400 {
            days.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return days
    }
    
}

#Preview {
    StatsView(user: User())
}
