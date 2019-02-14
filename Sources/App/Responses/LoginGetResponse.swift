//
//  LoginGetResponse.swift
//  App
//
//  Created by Renan Greca on 11/02/2019.
//

import Foundation

struct LoginGetResponse: Codable {
    let users:[User]
    let errorMessage:String
    let successMessage:String
}
