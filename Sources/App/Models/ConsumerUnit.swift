//
//  ConsumerUnit.swift
//  App
//
//  Created by Renan Greca on 15/02/2019.
//

import FluentSQLite
import Vapor

final class ConsumerUnit: SQLiteModel {
    var id: Int?
    
    let name:String
    
    var region:Region?
    var manager:User?
    var vehicleCount:Int = 0
    
    let batteryCapacity:Int // kWh
    let energyPeak:Int // kW
    let generationPeak:Int // kW
    let demand:Int // kW
    
    init(id: Int? = nil, name:String, region:Region?, manager:User?, batteryCapacity:Int, energyPeak:Int, generationPeak: Int, demand:Int) {
        self.id = id
        
        self.name = name
        self.region = region
        self.manager = manager
        self.batteryCapacity = batteryCapacity
        self.energyPeak = energyPeak
        self.generationPeak = generationPeak
        self.demand = demand
    }
}

extension ConsumerUnit: Migration { }
extension ConsumerUnit: Content { }
extension ConsumerUnit: Parameter { }

