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
            vehicle.lastCharged = randomDateInPastWeek()
            vehicle.costPerKM = Double.random(between: 0.0, and: 1.0).rounded(toPlaces: 2)
            vehicle.consumerUnit = currentConsumerUnit
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
    
    func vehicles(of consumerUnit: ConsumerUnit, _ req: Request) throws -> Future<[Vehicle]> {
        
        return Vehicle.query(on: req).all().map { vehicles in
            return vehicles.filter({
                $0.consumerUnit?.id == consumerUnit.id
            })
        }
        
    }
}
