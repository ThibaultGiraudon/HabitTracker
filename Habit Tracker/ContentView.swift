//
//  ContentView.swift
//  Habit Tracker
//
//  Created by Thibault Giraudon on 10/08/2024.
//

import SwiftUI

struct ContentView: View {
    @Namespace private var animation
    @StateObject var user = User()
    @State private var activeTab: Tab = .habits
    @State private var showingSheet = false
    var body: some View {
        ZStack(alignment: .bottom) {
            if activeTab == .habits {
                HabitView(user: user)
            }
            else if activeTab == .calendar {
                CalendarView(user: user)
            }
            else {
                StatsView(user: user)
            }
            HStack {
                ForEach(Tab.allCases) { tab in
                    Image(systemName: activeTab == .habits && tab == .habits ? "plus" : tab.rawValue)
                        .frame(width: 50, height: 50)
                        .foregroundStyle(activeTab == tab ? Color("TextColor") :
                                Color("OffWhite"))
                        .background {
                            if activeTab == tab {
                                Circle()
                                    .fill(Color("OffWhite"))
                                    .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                            }
                        }
                        .onTapGesture {
                            if activeTab == .habits && tab == .habits {
                                showingSheet = true
                            }
                            withAnimation(.snappy) {
                                activeTab = tab
                            }
                            if activeTab == .stats {
                                user.loadHighlights()
                            }
                        }
                }
            }
            .padding(5)
            .background {
                Capsule()
                    .fill(Color("TextColor"))
            }
            .sheet(isPresented: $showingSheet) {
                NavigationStack {
                    AddHabitView(user: user)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
