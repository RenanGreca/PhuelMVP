//
//  StationController.swift
//  App
//
//  Created by Renan Greca on 12/02/2019.
//

import Vapor

final class StationController {
    func index(_ req: Request) throws -> Future<[Station]> {
        return Station.query(on: req).all()
    }
    
    func create(_ req: Request) throws -> Future<Station> {
        return try req.content.decode(Station.self).flatMap { vehicleModel in
            return vehicleModel.save(on: req)
        }
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Station.self).flatMap { vehicleModel in
            return vehicleModel.delete(on: req)
        }.transform(to: .ok)
    }
    
    func list(_ req: Request) throws -> Future<[Station]> {
        return Station.query(on: req).all()
    }
}
