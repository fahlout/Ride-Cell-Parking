//
//  DoubleTransform.swift
//  RideCellParking
//
//  Created by Niklas Fahl on 1/14/17.
//  Copyright © 2017 Niklas Fahl. All rights reserved.
//

import Foundation

open class DoubleTransform: TransformType {
    public typealias Object = Double
    public typealias JSON = String
    
    public init() {}
    
    public func transformFromJSON(_ value: Any?) -> Double? {
        if let stringValue = value as? String {
            return Double(stringValue)
        }
        
        if let double = value as? Double {
            return double
        }
        
        return nil
    }
    
    public func transformToJSON(_ value: Double?) -> String? {
        if let double = value {
            return "\(double)"
        }
        return nil
    }
}
