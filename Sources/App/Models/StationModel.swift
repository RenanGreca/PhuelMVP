//
//  StationModel.swift
//  App
//
//  Created by Renan Greca on 17/02/2019.
//

import FluentSQLite
import Vapor

final class StationModel: SQLiteModel {
    var id: Int?
    
    let make:String
    let model:String
    let power:Double
    let extras:String
    
    init(id:Int? = nil, make:String, model:String, power:Double, extras:String) {
        self.id = id
        
        self.make = make
        self.model = model
        self.power = power
        self.extras = extras
    }
}

extension StationModel: Migration { }
extension StationModel: Content { }
extension StationModel: Parameter { }
