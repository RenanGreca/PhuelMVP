//
//  Dashboard.swift
//  App
//
//  Created by Renan Greca on 11/02/2019.
//

import Foundation

struct DashboardVehicleResponse: Codable {
    let vehicles:[Vehicle]
    let errorMessage:String
    let successMessage:String
}
