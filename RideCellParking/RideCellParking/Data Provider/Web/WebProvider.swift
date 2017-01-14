//
//  WebProvider.swift
//  RideCellParking
//
//  Created by Niklas Fahl on 1/14/17.
//  Copyright © 2017 Niklas Fahl. All rights reserved.
//

import Foundation
import CoreLocation

enum HttpMethod: String {
    case get = "GET",
    post = "POST",
    patch = "PATCH",
    put = "PUT",
    delete = "DELETE"
}

class WebProvider: DataProviderProtocol {
    var operationQueue = OperationQueue()
    
    let urlSession: URLSession
    
    init(sessionConfiguration: URLSessionConfiguration) {
        self.urlSession = URLSession(configuration:sessionConfiguration)
    }
    
    let baseAddress: String = "http://ridecellparking.herokuapp.com"
    
    // MARK: - Parking Locations
    func getParkingLocations(response: @escaping ([ParkingLocation]) -> Void, error: @escaping ((Error) -> Void)) -> DataProviderOperationProtocol {
        return makeJsonArrayRequest(method: .get, action: "/api/v1/parkinglocations", completion: response, error: error)
    }
    
    func getParkingLocation(for id: Int, response: @escaping (ParkingLocation) -> Void, error: @escaping ((Error) -> Void)) -> DataProviderOperationProtocol {
        return makeJsonRequest(method: .get, action: "/api/v1/parkinglocations/\(id)", completion: response, error: error)
    }
    
    func searchParkingLocations(for coordinates: CLLocationCoordinate2D, response: @escaping ([ParkingLocation]) -> Void, error: @escaping ((Error) -> Void)) -> DataProviderOperationProtocol {
        return makeJsonArrayRequest(method: .get, action: "/api/v1/parkinglocations/search?lat=\(coordinates.latitude)&lng=\(coordinates.longitude)", completion: response, error: error)
    }
    
    func reserveParkingLocation(for id: Int, minutes: ReservationRequestMinutes, response: @escaping (ParkingLocation) -> Void, error: @escaping ((Error) -> Void)) -> DataProviderOperationProtocol {
        return makeJsonRequest(method: .post, action: "/api/v1/parkinglocations/\(id)/reserve", body: minutes, completion: response, error: error)
    }
    
    func resetParkingLocation(for id: Int, response: @escaping (ParkingLocation) -> Void, error: @escaping ((Error) -> Void)) -> DataProviderOperationProtocol {
        return makeJsonRequest(method: .patch, action: "/api/v1/parkinglocations/\(id)", body: ReservationReset(), completion: response, error: error)
    }
}

// URL Request
extension WebProvider {
    func makeJsonArrayRequest<RT:StaticMappable>(method: HttpMethod, action: String, headers: [String:String] = [:], completion:@escaping ([RT]) -> (), error: @escaping (Error) -> ()) -> DataProviderOperationProtocol {
        
        let url = "\(baseAddress)\(action)"
        var request = URLRequest(url: URL(string:url)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20.0)
        
        //Add headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        //Add body data
        request.httpBody = nil
        request.httpMethod = method.rawValue
        
        let task = urlSession.dataTask(with: request) {(data, response, taskError)  -> Void in
            
            //Clean the response to be traditional http response
            let httpResponse = self.cleanResponse(urlResponse: response)
            
            if httpResponse.wasSuccessful {
                let responseString = String(data: data!, encoding: String.Encoding.utf8)!
                print(responseString)
                
                if let mappedObject = Mapper<RT>().mapArray(JSONString: responseString) {
                    DispatchQueue.main.async {
                        completion(mappedObject)
                    }
                }
                else {
                    let parseError = MapError(key: "", currentValue: "", reason: "Error parsing response object: \(RT.self)")
                    DispatchQueue.main.async {
                        error(parseError)
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    error(WebProviderError(error: taskError))
                }
            }
        }
        task.resume()
        
        return task
    }
    
    func makeJsonRequest<RT:StaticMappable>(method: HttpMethod, action: String, headers: [String:String] = [:], completion:@escaping (RT) -> (), error: @escaping (Error) -> ()) -> DataProviderOperationProtocol {
        
        let url = "\(baseAddress)\(action)"
        var request = URLRequest(url: URL(string:url)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20.0)
        
        //Add headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        //Add body data
        request.httpBody = nil
        request.httpMethod = method.rawValue
        
        let task = urlSession.dataTask(with: request) {(data, response, taskError)  -> Void in
            
            //Clean the response to be traditional http response
            let httpResponse = self.cleanResponse(urlResponse: response)
            
            if httpResponse.wasSuccessful {
                let responseString = String(data: data!, encoding: String.Encoding.utf8)!
                print(responseString)
                
                if let mappedObject = Mapper<RT>().map(JSONString: responseString) {
                    DispatchQueue.main.async {
                        completion(mappedObject)
                    }
                }
                else {
                    let parseError = MapError(key: "", currentValue: "", reason: "Error parsing response object: \(RT.self)")
                    DispatchQueue.main.async {
                        error(parseError)
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    error(WebProviderError(error: taskError))
                }
            }
        }
        task.resume()
        
        return task
    }
    
    func makeJsonRequest<T:StaticMappable,RT:StaticMappable>(method: HttpMethod, action: String, headers: [String:String] = [:], body: T?, completion: @escaping (RT) -> (), error: @escaping (Error) -> ()) -> DataProviderOperationProtocol {
        
        let url = "\(baseAddress)\(action)"
        var request = URLRequest(url: URL(string:url)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20.0)
        
        //Add headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        //Add body data
        // Create JSON String from Model
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body!.toJSON(), options: [])
            print(String(data: jsonData, encoding: String.Encoding.utf8)!)
            request.httpBody = jsonData
        } catch {
            
        }
        request.httpMethod = method.rawValue
        
        let task = urlSession.dataTask(with: request) {(data, response, taskError)  -> Void in
            
            //Clean the response to be traditional http response
            let httpResponse = self.cleanResponse(urlResponse: response)
            
            if httpResponse.wasSuccessful {
                let responseString = String(data: data!, encoding: String.Encoding.utf8)!
                print(responseString)
                
                if let mappedObject = Mapper<RT>().map(JSONString: responseString) {
                    DispatchQueue.main.async {
                        completion(mappedObject)
                    }
                }
                else {
                    let parseError = MapError(key: "", currentValue: "", reason: "Error parsing response object: \(RT.self)")
                    DispatchQueue.main.async {
                        error(parseError)
                    }
                }
            }
            else {
                if data != nil {
                    let responseString = String(data: data!, encoding: String.Encoding.utf8)!
                    print(responseString)
                }
                DispatchQueue.main.async {
                    error(WebProviderError(error: taskError))
                }
            }
        }
        task.resume()
        
        return task
    }
    
    func makeVoidRequest(method: HttpMethod, action: String, headers: [String:String] = [:], completion:() -> (), error: (Error) -> ()) -> DataProviderOperationProtocol {
        
        
        return URLSessionTask()
    }
    
    func makeVoidRequest<T>(method: HttpMethod, action: String, headers: [String:String] = [:], body: T?, completion:() -> (), error: (Error) -> ()) -> DataProviderOperationProtocol {
        
        
        return URLSessionTask()
    }
}

extension WebProvider {
    func cleanResponse(urlResponse: URLResponse?) -> HTTPURLResponse {
        if urlResponse != nil {
            return (urlResponse! as! HTTPURLResponse)
        }
        else {
            let httpResponse = HTTPURLResponse(url: URL(string:"com.webprovider")!, statusCode: 500, httpVersion: "", headerFields: [:])
            return httpResponse!
        }
    }
}

extension HTTPURLResponse {
    var wasSuccessful: Bool {
        return (self.statusCode >= 200 && self.statusCode < 300)
    }
}

class WebProviderError: Error {
    init() {
        
    }
    
    init(error: Error?) {
        
    }
}
