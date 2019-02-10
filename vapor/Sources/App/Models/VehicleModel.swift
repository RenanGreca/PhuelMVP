//
//  VehicleModel.swift
//  App
//
//  Created by Renan Greca on 09/02/2019.
//

import Foundation
import FluentSQLite
import Vapor

final class VehicleModel: SQLiteModel, Codable {
    var id: Int?
    
    let make: String
    let model: String
    let battery: [Int]
    
    init(id: Int? = nil, make: String, model: String, battery: [Int]) {
        self.id = id
        self.make = make
        self.model = model
        self.battery = battery
    }
}

extension VehicleModel: Migration { }
extension VehicleModel: Content { }
extension VehicleModel: Parameter { }
