//
//  StationModelController.swift
//  App
//
//  Created by Renan Greca on 17/02/2019.
//

import Vapor

final class StationModelController {
    func index(_ req: Request) throws -> Future<[StationModel]> {
        return StationModel.query(on: req).all()
    }
    
    func create(_ req: Request) throws -> Future<StationModel> {
        return try req.content.decode(StationModel.self).flatMap { stationModel in
            return stationModel.save(on: req)
        }
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(StationModel.self).flatMap { stationModel in
            return stationModel.delete(on: req)
            }.transform(to: .ok)
    }
    
    func list(_ req: Request) throws -> Future<View> {
        let allStationModels = StationModel.query(on: req).all()
        
        return allStationModels.flatMap { stationModels in
            //            let success = try req.parameters.next(Int.self)
            let data = ["stationModels": stationModels]
            return try req.view().render("stations-new", data)
        }
    }
}
