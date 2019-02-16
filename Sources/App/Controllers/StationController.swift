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
        print(req)
        return try req.content.decode(Station.self).flatMap { station in
            station.status = StationStatus.allCases.randomElement()!.rawValue
            station.lastUsed = randomDateInPastWeek()
            station.consumerUnit = currentConsumerUnit
            return station.save(on: req)
        }
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Station.self).flatMap { station in
            return station.delete(on: req)
        }.transform(to: .ok)
    }
    
    func list(_ req: Request) throws -> Future<[Station]> {
        return Station.query(on: req).all()
    }
    
    func stations(of consumerUnit: ConsumerUnit, _ req: Request) throws -> Future<[Station]> {
        
        return Station.query(on: req).all().map { stations in
            return stations.filter({
                $0.consumerUnit?.id == consumerUnit.id
            })
        }
        
    }
}
