//
//  VehicleController.swift
//  App
//
//  Created by Renan Greca on 09/02/2019.
//

import Vapor

final class VehicleController {
    func index(_ req: Request) throws -> Future<[Vehicle]> {
        return Vehicle.query(on: req).all()
    }
    
    func create(_ req: Request) throws -> Future<Vehicle> {
        return try req.content.decode(Vehicle.self).flatMap { Vehicle in
            return Vehicle.save(on: req)
        }
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Vehicle.self).flatMap { Vehicle in
            return Vehicle.delete(on: req)
        }.transform(to: .ok)
    }
    
    func list(_ req: Request) throws -> Future<View> {
        let allVehicles = Vehicle.query(on: req).all()
        
        return allVehicles.flatMap { users in
            let data = ["vehicles": users]
            return try req.view().render("dashboard", data)
        }
    }

}
