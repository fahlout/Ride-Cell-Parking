//
//  ParkingLocation.swift
//  RideCellParking
//
//  Created by Niklas Fahl on 1/14/17.
//  Copyright © 2017 Niklas Fahl. All rights reserved.
//

import Foundation

class ParkingLocation {
    var id = 0
    var latitude = 0.0
    var longitude = 0.0
    var name = ""
    var costPerMinute = 0.0
    var maxReserveTimeMins = 0
    var minReserveTimeMins = 0
    var isReserved = false
    var reservedUntil = Date()
    
    init() {
        
    }
}
