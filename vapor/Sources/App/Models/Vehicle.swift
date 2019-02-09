//
//  Vehicle.swift
//  PhuelMVP
//
//  Created by Renan Greca on 09/02/2019.
//

import FluentSQLite
import Vapor

final class Vehicle: SQLiteModel, Codable {
    
    var id: Int?
    
    var licensePlate: String
    var make: String
    var model: String
    
    var charge: Int
    
    init(id: Int? = nil, licensePlate: String, make: String, model: String, charge: Int) {
        self.id = id
        self.licensePlate = licensePlate
        self.make = make
        self.model = model
        self.charge = charge
    }
    
    
}

extension Vehicle: Migration { }
extension Vehicle: Content { }
extension Vehicle: Parameter { }
