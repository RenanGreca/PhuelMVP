//
//  DashboardRegionResponse.swift
//  App
//
//  Created by Renan Greca on 15/02/2019.
//

import Foundation

struct DashboardRegionResponse: Codable {
    let region:Region
    let errorMessage:String
    let successMessage:String
}
