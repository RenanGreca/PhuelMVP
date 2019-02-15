//
//  UserController.swift
//  App
//
//  Created by Renan Greca on 11/02/2019.
//

import Vapor

final class UserController {
    
    func list(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }
    
//    func userWith(/)
    
}
