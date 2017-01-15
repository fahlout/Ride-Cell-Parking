//
//  ParkingLocationAnnotation.swift
//  RideCellParking
//
//  Created by Niklas Fahl on 1/14/17.
//  Copyright © 2017 Niklas Fahl. All rights reserved.
//

import Foundation
import MapKit

class ParkingLocationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var parkingLocation = ParkingLocation()
    
    var annotationView: MKAnnotationView {
        get {
            return ParkingLocationAnnotationView(annotation: self)
        }
    }
    
    init(parkingLocation: ParkingLocation) {
        self.parkingLocation = parkingLocation
        self.coordinate = CLLocationCoordinate2D(latitude: parkingLocation.latitude as CLLocationDegrees, longitude: parkingLocation.longitude as CLLocationDegrees)
        
        super.init()
    }
}
