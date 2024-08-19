//
//  Symboles.swift
//  Habit Tracker
//
//  Created by Thibault Giraudon on 06/08/2024.
//

import Foundation

var symbols: [String] = Bundle.main.decode("symbols")

extension Bundle {
    func decode(_ fileName: String) -> [String] {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "txt") {
            if let data = try? String(contentsOf: url) {
                let datas = data.components(separatedBy: "\n")
                
                return datas
            }
        }
        fatalError("Failed to load \(fileName).txt")
    }
}
