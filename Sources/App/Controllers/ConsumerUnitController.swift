//
//  ConsumerUnitController.swift
//  App
//
//  Created by Renan Greca on 15/02/2019.
//

import Vapor

final class ConsumerUnitController {
    
    func index(_ req: Request) throws -> Future<[ConsumerUnit]> {
        return ConsumerUnit.query(on: req).all()
    }
    
    func create(_ req: Request) throws -> Future<ConsumerUnit> {
        return try req.content.decode(NewConsumerUnitRequest.self).flatMap { consumerUnitRequest in
            return Region.query(on: req).all().flatMap() { regions in
                let region = regions.filter({$0.id == consumerUnitRequest.region}).first
                return User.query(on: req).all().flatMap() { users in
                    let user = users.filter({$0.id == consumerUnitRequest.user}).first
                    
                    let consumerUnit = ConsumerUnit(name: consumerUnitRequest.name, region: region, manager: user, batteryCapacity: consumerUnitRequest.capacity, energyPeak: consumerUnitRequest.power, generationPeak: consumerUnitRequest.generation, demand: consumerUnitRequest.demand)
                    
                    user?.consumerUnit = consumerUnit.name
                    let _ = user?.update(on: req)
                    
                    return consumerUnit.save(on: req)
//                    return req.redirect(to: "dashboard")
                    
                }
            }
        } //.transform(to: req.redirect(to: "dashboard").future(req.redirect(to: "dashboard")))
    }
    
    func list(_ req: Request) throws -> Future<[ConsumerUnit]> {
        return ConsumerUnit.query(on: req).all()
    }
    
    func item(managedBy user: User, _ req: Request) throws -> Future<ConsumerUnit?> {
        return ConsumerUnit.query(on: req).all().map { units in
            return units.filter({
                $0.manager?.id == user.id
            }).first
        }
    }
    
    let regionController = RegionController()
    
    /**
     Recursively find all consumer units of a region and its sub-regions.
     */
    func consumerUnits(of region: Region, _ req: Request) throws -> Future<[ConsumerUnit]> {
        
        // Find all sub-regions of the given region
        return try regionController.subRegions(of: region, req).flatMap() { regions -> Future<[ConsumerUnit]> in
            if regions.count > 0 {
                // If there are sub-regions, recursively find the consumer units of all sub-regions
                return try self.accumulateResults(of: regions, index: 0, partial: [], req).flatMap() { results  -> Future<[ConsumerUnit]> in
                    // Add sub-region consumer units with current region's consumer units
                    return ConsumerUnit.query(on: req).all().map() { consumerUnits in
                        let units = consumerUnits.filter({ $0.region?.id == region.id })
                        
                        return units + results
                    }
                }
            } else {
                // If there are no sub-regions, return just the current region's consumer units
                return ConsumerUnit.query(on: req).all().map() { consumerUnits in
                    return consumerUnits.filter({ $0.region?.id == region.id })
                }
            }
        }
        
    }
    
    /**
     Recursively aggregate all the consumer units of an array of regions into a single array
     */
    func accumulateResults(of regions: [Region], index: Int, partial:[ConsumerUnit], _ req: Request) throws -> Future<[ConsumerUnit]> {
        if index == regions.count-1 {
            // If this is the last item in the array, return the partial results plus the current region's consumer unit
            return try self.consumerUnits(of: regions[index], req).map() { consumerUnits in
                 partial+consumerUnits
            }
        } else {
            // Otherwise combine the arrays and resume the recursion
            return try self.consumerUnits(of: regions[index], req).flatMap() { consumerUnits in
                return try self.accumulateResults(of: regions, index: index+1, partial:partial+consumerUnits, req)
            }
        }
        
    }
    
}
