//
//  functions.swift
//  App
//
//  Created by Renan Greca on 13/02/2019.
//

import Foundation

// Generates a random date up to 7 days ago
func randomDateInPastWeek() -> Date {
    
    let calendar = Calendar(identifier: .gregorian)
    let date = calendar.date(byAdding: .day, value: -7, to: Date())!
    
    let interval = Date().timeIntervalSince(date)
    let range = Range<Double>(uncheckedBounds: (lower: 0, upper: interval))
    let randomInterval = Double.random(in: range)
    
    let randomDate = date.addingTimeInterval(randomInterval)
    
    return randomDate
}

extension Double {
    
    // Generates a random value between two Doubles
    static func random(between a: Double, and b: Double) -> Double {
        let range = Range<Double>(uncheckedBounds: (lower: a, upper: b))
        return Double.random(in: range)
    }
    
    // Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
