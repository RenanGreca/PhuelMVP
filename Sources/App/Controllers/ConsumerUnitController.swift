//
//  ConsumerUnitController.swift
//  App
//
//  Created by Renan Greca on 15/02/2019.
//

import Vapor

final class ConsumerUnitController {
    
    func list(_ req: Request) throws -> Future<[ConsumerUnit]> {
        return ConsumerUnit.query(on: req).all()
    }
    
    func item(managedBy user: User, _ req: Request) throws -> Future<ConsumerUnit?> {
        return ConsumerUnit.query(on: req).all().map { units in
            return units.filter({
                $0.manager?.id == user.id
            }).first
        }
    }
    
}
