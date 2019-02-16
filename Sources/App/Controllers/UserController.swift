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
    
    func create(_ req: Request) throws -> Future<User> {
        print(req)
        return try req.content.decode(NewUserRequest.self).flatMap() { userRequest in
            let user = User(name: userRequest.name, email: userRequest.email, password: userRequest.password)
            
            return user.save(on: req)
        }
    }
    
    func notManagers(_ req: Request) throws -> Future <[User]> {
        return User.query(on: req).all().map() { users in
            return users.filter({
                $0.consumerUnit == nil &&
                $0.region == nil
            })
        }
    }
    
}
