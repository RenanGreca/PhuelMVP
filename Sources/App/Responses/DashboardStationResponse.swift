//
//  DashboardStationResponse.swift
//  App
//
//  Created by Renan Greca on 12/02/2019.
//

import Foundation

struct DashboardStationResponse: Codable {
    let consumerUnit:ConsumerUnit?
    let stations:[Station]
    let errorMessage:String
    let successMessage:String
}
