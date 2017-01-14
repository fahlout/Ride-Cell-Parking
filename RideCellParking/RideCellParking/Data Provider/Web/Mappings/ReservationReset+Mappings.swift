//
//  ReservationReset+Mappings.swift
//  RideCellParking
//
//  Created by Niklas Fahl on 1/14/17.
//  Copyright © 2017 Niklas Fahl. All rights reserved.
//

import Foundation

extension ReservationReset : StaticMappable {
    static func objectForMapping(map: Map) -> BaseMappable? {
        return ReservationReset()
    }
    
    // Mappable
    func mapping(map: Map) {
        isReserved <- map["is_reserved"]
        reservedUntil <- map["reserved_until"]
    }
}
