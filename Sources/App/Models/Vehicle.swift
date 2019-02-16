//
//  Vehicle.swift
//  PhuelMVP
//
//  Created by Renan Greca on 09/02/2019.
//

import FluentSQLite
import Vapor

final class Vehicle: SQLiteModel {
    
    var id: Int?
    
    let licensePlate: String
    var charge:Int?
    
    let modelId: Int
    let make: String
    let model: String
    let battery: Int
    var lastCharged: Date?
    var costPerKM: Double?
    var consumerUnit: ConsumerUnit?
    
    init(id: Int? = nil, licensePlate: String, modelId: Int, make: String, model: String, battery: Int, consumerUnit: ConsumerUnit) {
        self.id = id
        self.licensePlate = licensePlate
        self.charge = Int.random(in: 0..<100)
        self.modelId = modelId
        self.make = make
        self.model = model
        self.battery = battery
        self.lastCharged = randomDateInPastWeek()
        self.costPerKM = Double.random(between: 0.0, and: 1.0).rounded(toPlaces: 2)
        self.consumerUnit = consumerUnit
    }
    
}

extension Vehicle: Migration { }
extension Vehicle: Content { }
extension Vehicle: Parameter { }
