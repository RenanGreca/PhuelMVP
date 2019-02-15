//
//  RegionController.swift
//  App
//
//  Created by Renan Greca on 15/02/2019.
//

import Vapor

final class RegionController {
    
    func list(_ req: Request) throws -> Future<[Region]> {
        return Region.query(on: req).all()
    }
    
    func item(managedBy user: User, _ req: Request) throws -> Future<Region?> {
        return Region.query(on: req).all().map { units in
            return units.filter({
                $0.manager?.id == user.id
            }).first
        }
    }
    
}
