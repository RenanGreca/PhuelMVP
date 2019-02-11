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
        print(req)
        return try req.content.decode(Vehicle.self).flatMap { vehicle in
            vehicle.charge = Int.random(in: 0..<100)
            return vehicle.save(on: req)
        }//.transform(to: req.redirect(to: "vehicles/new"))
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Vehicle.self).flatMap { vehicle in
            return vehicle.delete(on: req)
        }.transform(to: .ok)
    }
    
    func list(_ req: Request) throws -> Future<[Vehicle]> {
        return Vehicle.query(on: req).all()
    }
}
