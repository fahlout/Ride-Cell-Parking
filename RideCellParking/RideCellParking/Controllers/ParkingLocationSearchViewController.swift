//
//  ParkingLocationSearchViewController.swift
//  RideCellParking
//
//  Created by Niklas Fahl on 1/14/17.
//  Copyright © 2017 Niklas Fahl. All rights reserved.
//

import UIKit
import MapKit

class ParkingLocationSearchViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    let defaultLocation = CLLocation(latitude: 37.7946, longitude: -122.3999) // San Francisco
    
    var didShowInitialUserLocation = false
    var didSearch = false
    var isSearchOpen = true
    var isLocationManagerAuthorized = false
    
    
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var searchViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var searchAgainButton: UIButton!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        title = "Search"
        
        let tabBarImage = UIImage(named: "ParkingLocation")
        tabBarItem.selectedImage = tabBarImage
        tabBarItem.image = tabBarImage
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialSetup() {
        addNavigationBarButtons()
        setupLocationManager()
        setLocation(to: locationManager.location)
    }
}

extension ParkingLocationSearchViewController {
    
    // MARK: - Navigation Bar Setup
    
    func addNavigationBarButtons() {
        let searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchBarButtonAction))
        navigationItem.rightBarButtonItem = searchBarButton
        
        let centerLocationButton = UIBarButtonItem(image: UIImage(named: "CenterLocation"), style: .plain, target: self, action: #selector(centerLocationBarButtonAction))
        navigationItem.leftBarButtonItem = centerLocationButton
    }
    
    // MARK: - Search Bar Button Action
    func searchBarButtonAction() {
        showSearchView(show: !isSearchOpen)
    }
    
    func showSearchView(show: Bool) {
        searchAgainButton.isHidden = true
        
        let newSearchTopConstraintConstant = show ? 0.0 : -searchViewHeightConstraint.constant
        searchViewTopConstraint.constant = newSearchTopConstraintConstant
        
        isSearchOpen = !isSearchOpen
        
        UIView.animate(withDuration: 0.3.seconds) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Center Location Bar Button Action
    func centerLocationBarButtonAction() {
        centerMapToUserLocation()
    }
    
    func centerMapToUserLocation() {
        if isLocationManagerAuthorized {
            guard let userLocation = locationManager.location else {
                print("Location has not been determinde yet.")
                return
            }
            
            setLocation(to: userLocation)
        } else {
            showAlert(with: "The use of your location has not been authorized. Please authorize the use of your location in settings.", message: nil)
        }
    }
}

extension ParkingLocationSearchViewController {
    
    // MARK: - Map
    
    func setLocation(to location: CLLocation?) {
        let newLocation = location ?? defaultLocation
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func removeAllAnnotations() {
        for annotation in mapView.annotations {
            if !(annotation is MKUserLocation) {
                mapView.removeAnnotation(annotation)
            }
        }
    }
    
    func addAnnotations(for parkingLocations: [ParkingLocation]) {
        for location in parkingLocations {
            let annotation = ParkingLocationAnnotation(parkingLocation: location)
            mapView.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is ParkingLocationAnnotation {
            return (annotation as! ParkingLocationAnnotation).annotationView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view is ParkingLocationAnnotationView {
            if let selectedAnnotation = mapView.selectedAnnotations.first {
                setLocation(to: CLLocation(latitude: selectedAnnotation.coordinate.latitude, longitude: selectedAnnotation.coordinate.longitude))
            }
            (view as! ParkingLocationAnnotationView).animateSelection()
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view is ParkingLocationAnnotationView {
            (view as! ParkingLocationAnnotationView).animateDeselection()
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if didSearch {
            searchAgainButton.isHidden = false
        }
    }
}

extension ParkingLocationSearchViewController {
    
    // MARK: - Location Manager
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func authorizationUpdated(to authorized: Bool) {
        locationManager.startUpdatingLocation()
        
        isLocationManagerAuthorized = authorized
        mapView.showsUserLocation = authorized
    }
    
    // MARK: - Location Manager Delegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            authorizationUpdated(to: true)
        } else {
            authorizationUpdated(to: false)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if isLocationManagerAuthorized && !didShowInitialUserLocation {
            didShowInitialUserLocation = true
            
            setLocation(to: locations.first)
        }
    }
}

extension ParkingLocationSearchViewController {
    
    // MARK: - Search
    
    // Time Slider Changed
    @IBAction func didChangeTimeSlider(_ sender: UISlider) {
        timeLabel.text =  "\(Int(sender.value)) min"
    }
    
    // Search
    func search() {
        showSearchView(show: false)
        removeAllAnnotations()
        
        let mapCenterCoordinate = mapView.centerCoordinate
        
        let _ = DataProvider.shared.searchParkingLocations(for: mapCenterCoordinate, response: { (parkingLocations: [ParkingLocation]) in
            if parkingLocations.count == 0 {
                self.showAlert(with: "No Results", message: "There are no parking locations in this area.")
            } else {
                self.didSearch = true
                
                // Add parking locations to map
                self.addAnnotations(for: parkingLocations)
            }
        }) { (error: Error) in
            self.showAlert(with: "Error", message: "Could not complete search. Try again later.")
        }
    }
    
    // Search Actions
    @IBAction func didTapSearch(_ sender: UIButton) {
        search()
    }
    
    @IBAction func didTapSearchAgain(_ sender: UIButton) {
        search()
    }
}
