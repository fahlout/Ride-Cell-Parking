//
//  ParkingLocationAnnotationView.swift
//  RideCellParking
//
//  Created by Niklas Fahl on 1/14/17.
//  Copyright © 2017 Niklas Fahl. All rights reserved.
//

import Foundation
import MapKit

class ParkingLocationAnnotationView: MapAnnotationView {
    
    init(annotation: ParkingLocationAnnotation) {
        let selectedImage = UIImage(named:"ParkingPin")
        let deselectedImage = UIImage(named:"ParkingPinSmall")
        super.init(annotation: annotation, reuseIdentifier: "ParkingLocationAnnotation", selectedImage: selectedImage!, deselectedImage: deselectedImage!)
        image = deselectedImage!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
