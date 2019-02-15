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
    var vehicles:[Vehicle] = []
    var stations:[Station] = []
    
    let region:Region
    var manager:User?
    
    let batteryCapacity:Int // kWh
    let energyPeak:Int // kW
    
    init(id: Int? = nil, name:String, vehicles:[Vehicle], stations:[Station], region:Region, manager:User, batteryCapacity:Int, energyPeak:Int) {
        self.id = id
        
        self.name = name
        self.vehicles = vehicles
        self.stations = stations
        self.region = region
        self.manager = manager
        self.batteryCapacity = batteryCapacity
        self.energyPeak = energyPeak
    }
}

extension ConsumerUnit: Migration { }
extension ConsumerUnit: Content { }
extension ConsumerUnit: Parameter { }

