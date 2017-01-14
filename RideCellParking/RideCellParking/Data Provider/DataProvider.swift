//
//  DataProvider.swift
//  RideCellParking
//
//  Created by Niklas Fahl on 1/14/17.
//  Copyright © 2017 Niklas Fahl. All rights reserved.
//

import Foundation
import CoreLocation

class DataProvider : DataProviderProtocol {
    var operationQueue = OperationQueue()
    var provider: DataProviderProtocol = WebProvider(sessionConfiguration: URLSessionConfiguration.default)
    
    static let shared = DataProvider()
}

extension DataProvider {
    func getParkingLocations(response: @escaping ([ParkingLocation]) -> Void, error: @escaping ((Error) -> Void)) -> DataProviderOperationProtocol {
        return provider.getParkingLocations(response: response, error: error)
    }
    
    func getParkingLocation(for id: Int, response: @escaping (ParkingLocation) -> Void, error: @escaping ((Error) -> Void)) -> DataProviderOperationProtocol {
        return provider.getParkingLocation(for: id, response: response, error: error)
    }
    
    func searchParkingLocations(for coordinates: CLLocationCoordinate2D, response: @escaping ([ParkingLocation]) -> Void, error: @escaping ((Error) -> Void)) -> DataProviderOperationProtocol {
        return provider.searchParkingLocations(for: coordinates, response: response, error: error)
    }
    
    func reserveParkingLocation(for id: Int, minutes: ReservationRequestMinutes, response: @escaping (ParkingLocation) -> Void, error: @escaping ((Error) -> Void)) -> DataProviderOperationProtocol {
        return provider.reserveParkingLocation(for: id, minutes: minutes, response: response, error: error)
    }
    
    func resetParkingLocation(for id: Int, response: @escaping (ParkingLocation) -> Void, error: @escaping ((Error) -> Void)) -> DataProviderOperationProtocol {
        return provider.resetParkingLocation(for: id, response: response, error: error)
    }
}
