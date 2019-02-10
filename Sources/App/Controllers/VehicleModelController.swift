//
//  VehicleModelModelController.swift
//  App
//
//  Created by Renan Greca on 09/02/2019.
//

import Vapor

final class VehicleModelController {
    func index(_ req: Request) throws -> Future<[VehicleModel]> {
        return VehicleModel.query(on: req).all()
    }
    
    func create(_ req: Request) throws -> Future<VehicleModel> {
        return try req.content.decode(VehicleModel.self).flatMap { vehicleModel in
            return vehicleModel.save(on: req)
        }
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(VehicleModel.self).flatMap { vehicleModel in
            return vehicleModel.delete(on: req)
        }.transform(to: .ok)
    }
    
    func list(_ req: Request) throws -> Future<View> {
        let allVehicleModels = VehicleModel.query(on: req).all()
        
        return allVehicleModels.flatMap { vehicleModels in
//            let success = try req.parameters.next(Int.self)
            let data = ["vehicleModels": vehicleModels]
            return try req.view().render("cadastros-veiculos", data)
        }
    }
}
