//
//  DataProviderProtocol.swift
//  RideCellParking
//
//  Created by Niklas Fahl on 1/14/17.
//  Copyright © 2017 Niklas Fahl. All rights reserved.
//

import Foundation
import CoreLocation

protocol DataProviderProtocol {
    
    // MARK: - Get All Parking Locations
    func getParkingLocations(response: @escaping ([ParkingLocation]) -> Void, error: @escaping ((Error) -> Void)) -> DataProviderOperationProtocol
    
    // MARK: - Get Parking Location By Id
    func getParkingLocation(for id: Int, response: @escaping (ParkingLocation) -> Void, error: @escaping ((Error) -> Void)) -> DataProviderOperationProtocol
    
    // MARK: - Search Parking Locations For Coordinates
    func searchParkingLocations(for coordinates: CLLocationCoordinate2D, response: @escaping ([ParkingLocation]) -> Void, error: @escaping ((Error) -> Void)) -> DataProviderOperationProtocol
    
    // MARK: - Reserve Parking Location
    func reserveParkingLocation(for id: Int, minutes: ReservationRequestMinutes, response: @escaping (ParkingLocation) -> Void, error: @escaping ((Error) -> Void)) -> DataProviderOperationProtocol
    
    // MARK: - Reset Parking Location
    func resetParkingLocation(for id: Int, response: @escaping (ParkingLocation) -> Void, error: @escaping ((Error) -> Void)) -> DataProviderOperationProtocol
}
