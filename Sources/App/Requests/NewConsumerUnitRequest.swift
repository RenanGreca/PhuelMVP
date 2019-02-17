//
//  NewConsumerUnitRequest.swift
//  App
//
//  Created by Renan Greca on 16/02/2019.
//

import Foundation

struct NewConsumerUnitRequest: Codable {
    let name: String
    let region:Int
    let user:Int
    let power:Int
    let generation:Int
    let capacity:Int
    let demand:Int
}
