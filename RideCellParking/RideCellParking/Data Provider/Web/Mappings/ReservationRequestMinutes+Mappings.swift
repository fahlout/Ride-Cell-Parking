//
//  ReservationRequestMinutes+Mappings.swift
//  RideCellParking
//
//  Created by Niklas Fahl on 1/14/17.
//  Copyright © 2017 Niklas Fahl. All rights reserved.
//

import Foundation

extension ReservationRequestMinutes : StaticMappable {
    static func objectForMapping(map: Map) -> BaseMappable? {
        return ReservationRequestMinutes()
    }
    
    // Mappable
    func mapping(map: Map) {
        minutes <- map["minutes"]
    }
}
