//
//  Region.swift
//  App
//
//  Created by Renan Greca on 15/02/2019.
//

import FluentSQLite
import Vapor

final class Region: SQLiteModel {
    
    var id: Int?
    
    let name:String
    let code:String
    let superRegion: Region?
    
    var manager: User?
    
    init(id:Int? = nil, name:String, code:String, superRegion:Region? = nil, manager: User) {
        self.id = id
        
        self.name = name
        self.code = code
        self.superRegion = superRegion
        self.manager = manager
        
    }
    
}

extension Region: Migration { }
extension Region: Content { }
extension Region: Parameter { }
