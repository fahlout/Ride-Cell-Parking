//
//  MapAnnotationView.swift
//  RideCellParking
//
//  Created by Niklas Fahl on 1/14/17.
//  Copyright © 2017 Niklas Fahl. All rights reserved.
//

import Foundation
import MapKit

class MapAnnotationView: MKAnnotationView {
    
    let deselectedImage: UIImage
    let selectedImage: UIImage
    
    init(annotation: MKAnnotation?, reuseIdentifier: String?, selectedImage: UIImage, deselectedImage: UIImage) {
        self.deselectedImage = deselectedImage
        self.selectedImage = selectedImage
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.deselectedImage = UIImage()
        self.selectedImage = UIImage()
        super.init(coder: aDecoder)
    }
    
    func animateSelection() {
        self.image = selectedImage
        
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.centerOffset = CGPoint(x: 0, y: -image!.size.height / 4)
        self.alpha = 0.0
        
        UIView.animate(withDuration: 0.5.second, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.centerOffset = CGPoint(x: 0, y: -self.image!.size.height / 2)
            self.alpha = 1.0
        }, completion: nil)
    }
    
    func animateDeselection() {
        UIView.animate(withDuration: 0.2.seconds, animations: {
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.centerOffset = CGPoint(x: 0, y: (-self.image!.size.height / 2) / 10)
            self.alpha = 0.0
        }) { (completed: Bool) in
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.image = self.deselectedImage
            self.alpha = 1.0
            self.centerOffset = CGPoint.zero
        }
    }
}
