//
//  RegionController.swift
//  App
//
//  Created by Renan Greca on 15/02/2019.
//

import Vapor

final class RegionController {
    
    func list(_ req: Request) throws -> Future<[Region]> {
        return Region.query(on: req).all()
    }
    
    func item(managedBy user: User, _ req: Request) throws -> Future<Region?> {
        return Region.query(on: req).all().map { regions in
            return regions.filter({
                $0.manager?.id == user.id
            }).first
        }
    }
    
    func subRegions(of region: Region, _ req: Request) throws -> Future<[Region]> {
        
        return Region.query(on: req).all().map { regions in
            return regions.filter({
                $0.superRegion?.id == region.id
            })
        }
        
    }
    
    func allSubRegions(of region: Region, _ req: Request) throws -> Future<[Region]> {
        
        return try self.subRegions(of: region, req).flatMap() { regions in
            if regions.count > 0 {
                return try self.accumulateResults(of: regions, index: 0, partial: [], req).map() { subregions in
                    return regions + subregions
                }
            } else {
                return Region.query(on: req).all().map { regions in
                    return []
                }
            }
        }
        
    }
    
    /**
     Recursively aggregate all the subregions of an array of regions into a single array
     */
    func accumulateResults(of regions: [Region], index: Int, partial:[Region], _ req: Request) throws -> Future<[Region]> {
        if index == regions.count-1 {
            // If this is the last item in the array, return the partial results plus the current region's consumer unit
            return try self.allSubRegions(of: regions[index], req).map() { subregions in
                partial+subregions
            }
        } else {
            // Otherwise combine the arrays and resume the recursion
            return try self.allSubRegions(of: regions[index], req).flatMap() { subregions in
                return try self.accumulateResults(of: regions, index: index+1, partial:partial+subregions, req)
            }
        }
        
    }
    
}
