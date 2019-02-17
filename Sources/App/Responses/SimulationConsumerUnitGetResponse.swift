//
//  SimulationConsumerUnitGetResponse.swift
//  App
//
//  Created by Renan Greca on 17/02/2019.
//

import Foundation

struct SimulationConsumerUnitGetResponse: Codable {
    let consumerUnit: ConsumerUnit?
    let vehicleCount: Int
}
