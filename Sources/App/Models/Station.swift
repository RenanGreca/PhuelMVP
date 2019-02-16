//
//  Station.swift
//  App
//
//  Created by Renan Greca on 12/02/2019.
//

import FluentSQLite
import Vapor

enum Current:String,Codable {
    case ac = "AC"
    case dc = "DC"
}

enum StationStatus:Int,Codable,CaseIterable {
    case inUse
    case available
    case underMaintenance
    
    static var random:StationStatus? {
        return self.allCases.randomElement()
    }
}

final class Station: SQLiteModel {
    
    var id: Int?
    
    let model: String
    let current: String // AC or DC
    let power: Int // kW or kVA
    let specifications: String
    var status: Int?
    var lastUsed: Date?
    var consumerUnit: ConsumerUnit?
    
    init(id: Int? = nil, model:String, current: String, power: Int, specifications: String, consumerUnit: ConsumerUnit) {
        self.id = id
        
        self.model = model
        self.current = current
        self.power = power
        self.specifications = specifications
        self.status = StationStatus.random?.rawValue
        self.lastUsed = randomDateInPastWeek()
        self.consumerUnit = consumerUnit
    }
    
}

extension Station: Migration { }
extension Station: Content { }
extension Station: Parameter { }
