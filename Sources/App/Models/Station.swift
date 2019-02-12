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
    
    var description:String {
        return self.rawValue
    }
}

final class Station: SQLiteModel {
    
    var id: Int?
    
    let model: String
    let current: String // AC or DC
    let power: Int // kW or kVA
    let specifications: String
    
    init(id: Int? = nil, model:String, current: String, power: Int, specifications: String) {
        self.id = id
        
        self.model = model
        self.current = current
        self.power = power
        self.specifications = specifications
    }
    
}

extension Station: Migration { }
extension Station: Content { }
extension Station: Parameter { }
