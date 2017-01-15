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
    
    init(annotation: ParkingLocationAnnotation, selectedImageName: String, deselectedImageName: String) {
        let selectedImage = UIImage(named: selectedImageName)
        let deselectedImage = UIImage(named: deselectedImageName)
        super.init(annotation: annotation, reuseIdentifier: "ParkingLocationAnnotation", selectedImage: selectedImage!, deselectedImage: deselectedImage!)
        image = deselectedImage!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
