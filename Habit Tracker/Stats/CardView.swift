//
//  CardView.swift
//  Habit Tracker
//
//  Created by Thibault Giraudon on 12/08/2024.
//

import SwiftUI

struct CardView: View {
    let image: String
    let title: String
    let value: String
    let color: Color
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 15)
                .fill(color)
            VStack(alignment: .leading) {
                Image(systemName: image)
                    .font(.title.bold())
                Text(value)
                    .font(.title.bold())
                Text(title)
            }
            .padding()
                
        }
        .foregroundStyle(Color("OffWhite"))
        .environment(\.colorScheme, .light)
    }
}

#Preview {
    CardView(image: "flame.fill", title: "Current streak", value: "\(0) Days", color: .blue)
        .frame(width: 300, height: 200)
}
