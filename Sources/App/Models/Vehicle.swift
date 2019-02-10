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
    var charge: Int
    
    let modelId: Int
    let make: String
    let model: String
    let battery: Int
    
    init(id: Int? = nil, licensePlate: String, charge: Int, modelId: Int, make: String, model: String, battery: Int) {
        self.id = id
        self.licensePlate = licensePlate
        self.charge = charge
        self.modelId = modelId
        self.make = make
        self.model = model
        self.battery = battery
    }
    
}

extension Vehicle: Migration { }
extension Vehicle: Content { }
extension Vehicle: Parameter { }
