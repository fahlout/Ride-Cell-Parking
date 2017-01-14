//
//  DataProviderOperationProtocol.swift
//  RideCellParking
//
//  Created by Niklas Fahl on 1/14/17.
//  Copyright © 2017 Niklas Fahl. All rights reserved.
//

import Foundation

extension ParkingLocation : StaticMappable {
    static func objectForMapping(map: Map) -> BaseMappable? {
        return ParkingLocation()
    }
    
    // Mappable
    func mapping(map: Map) {
        id <- map["id"]
        latitude <- (map["lat"], DoubleTransform())
        longitude <- (map["lng"], DoubleTransform())
        name <- map["name"]
        costPerMinute <- (map["cost_per_minute"], DoubleTransform())
        maxReserveTimeMins <- map["max_reserve_time_mins"]
        minReserveTimeMins <- map["min_reserve_time_mins"]
        isReserved <- map["is_reserved"]
        reservedUntil <- (map["reserved_until"], DateTransform())
    }
}
