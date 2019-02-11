//
//  User.swift
//  App
//
//  Created by Renan Greca on 11/02/2019.
//

import FluentSQLite
import Vapor
import Authentication
import Crypto

final class User: SQLiteModel {
    
    var id: Int?
    
    var name: String
    var email: String
    var password: String
    var passwordHash: String
    
    init(id: Int? = nil, name: String, email: String, password: String) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        
        self.passwordHash = try! BCrypt.hash(password)
    }
    
}

extension User: Migration { }
extension User: Content { }
extension User: Parameter { }
extension User: SessionAuthenticatable { }

extension User: PasswordAuthenticatable {
    /// See `PasswordAuthenticatable`.
    static var usernameKey: WritableKeyPath<User, String> {
        return \.email
    }
    
    /// See `PasswordAuthenticatable`.
    static var passwordKey: WritableKeyPath<User, String> {
        return \.passwordHash
    }
}
