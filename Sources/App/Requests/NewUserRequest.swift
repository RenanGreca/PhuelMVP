//
//  NewUserRequest.swift
//  App
//
//  Created by Renan Greca on 16/02/2019.
//

import Foundation

struct NewUserRequest: Codable {
    let name: String
    let email: String
    let password: String
}
