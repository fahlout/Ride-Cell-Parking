//
//  ParkingLocationSearchViewController.swift
//  RideCellParking
//
//  Created by Niklas Fahl on 1/14/17.
//  Copyright © 2017 Niklas Fahl. All rights reserved.
//

import UIKit
import MapKit

class ParkingLocationSearchViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, ReservationDelegate {
    
    let metersPerMile = 1609.344

    let defaultLocation = CLLocation(latitude: 37.7946, longitude: -122.3999) // San Francisco
    
    var didShowInitialUserLocation = false
    var didSearch = false
    var isSearchOpen = true
    var isParkingLocationQuickViewOpen = false
    var isLocationManagerAuthorized = false
    
    var locationManager: CLLocationManager!
    let geocoder = CLGeocoder()
    
    // Map
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchAgainButton: UIButton!
    
    // Search View
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    
    @IBOutlet weak var searchViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchViewHeightConstraint: NSLayoutConstraint!
    
    // Parking Location Quick View
    var parkingLocationAddress: String?
    
    @IBOutlet weak var parkingLocationAddressLabel: UILabel!
    @IBOutlet weak var parkingLocationNameLabel: UILabel!
    @IBOutlet weak var parkingLocationCostLabel: UILabel!
    @IBOutlet weak var parkingLocationDistanceLabel: UILabel!
    @IBOutlet weak var parkingLocationPayAndReserveButton: UIButton!
    
    @IBOutlet weak var parkingLocationQuickViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var parkingLocationQuickViewHeightConstraint: NSLayoutConstraint!
    
    // Live cycle
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
        showParkingLocationQuickView(show: false, for: nil)
        
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
        
        let newTopConstraintConstant = show ? 0.0 : -searchViewHeightConstraint.constant
        searchViewTopConstraint.constant = newTopConstraintConstant
        
        isSearchOpen = show
        
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
    
    func getSelectedParkingLocation() -> ParkingLocation? {
        if let selectedAnnotation: ParkingLocationAnnotation = mapView.selectedAnnotations.first as? ParkingLocationAnnotation {
            return selectedAnnotation.parkingLocation
        }
        
        return nil
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
            if let selectedParkingLocation = getSelectedParkingLocation() {
                setLocation(to: CLLocation(latitude: selectedParkingLocation.latitude, longitude: selectedParkingLocation.longitude))
                
                showParkingLocationQuickView(show: true, for: selectedParkingLocation)
            }
            (view as! ParkingLocationAnnotationView).animateSelection()
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view is ParkingLocationAnnotationView {
            (view as! ParkingLocationAnnotationView).animateDeselection()
            
            showParkingLocationQuickView(show: false, for: nil)
            parkingLocationAddress = nil
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

extension ParkingLocationSearchViewController {
    
    // MARK: - Parking Location Quick View
    
    func showParkingLocationQuickView(show: Bool, for parkingLocation: ParkingLocation?) {
        if let parkingLocation = parkingLocation {
            setParkingLocationQuickView(for: parkingLocation)
        }
        
        let newTopConstraintConstant = show ? 0.0 : -parkingLocationQuickViewHeightConstraint.constant
        parkingLocationQuickViewBottomConstraint.constant = newTopConstraintConstant
        
        isParkingLocationQuickViewOpen = !isParkingLocationQuickViewOpen
        
        UIView.animate(withDuration: 0.3.seconds) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setParkingLocationQuickView(for parkingLocation: ParkingLocation) {
        updateParkingLocationReserveButton(for: parkingLocation)
        
        parkingLocationNameLabel.text = parkingLocation.name
        parkingLocationCostLabel.text = "$\(String(format: "%.02f", parkingLocation.costPerMinute))/min"
        setParkingLocationDistance(for: parkingLocation)
        setParkingLocationAddress(for: parkingLocation)
    }
    
    func updateParkingLocationReserveButton(for parkingLocation: ParkingLocation) {
        parkingLocationPayAndReserveButton.isEnabled = !parkingLocation.isReserved
        if parkingLocation.isReserved {
            parkingLocationPayAndReserveButton.backgroundColor = .darkGray
            parkingLocationPayAndReserveButton.setTitle("Reserved", for: .normal)
        } else {
            parkingLocationPayAndReserveButton.backgroundColor = .rideCellBlue
            parkingLocationPayAndReserveButton.setTitle("Pay and Reserve", for: .normal)
        }
    }
    
    func setParkingLocationDistance(for parkingLocation: ParkingLocation) {
        guard let userLocation = locationManager.location else {
            print("Location has not been determinde yet.")
            parkingLocationDistanceLabel.text = "N/A"
            return
        }
        
        let parkingLocationCoordinates = CLLocation(latitude: parkingLocation.latitude, longitude: parkingLocation.longitude)
        parkingLocationDistanceLabel.text = "\(String(format: "%.02f", userLocation.distance(from: parkingLocationCoordinates)/metersPerMile))miles"
    }
    
    func setParkingLocationAddress(for parkingLocation: ParkingLocation) {
        parkingLocationAddressLabel.text = "Loading..."
        
        let parkingLocationCoordinates = CLLocation(latitude: parkingLocation.latitude, longitude: parkingLocation.longitude)
        geocoder.reverseGeocodeLocation(parkingLocationCoordinates) { (placemarks: [CLPlacemark]?, error: Error?) in
            guard let placemark = placemarks?[0] else {
                self.parkingLocationAddressLabel.text = "Address not available"
                return
            }
            
            let address = "\(placemark.subThoroughfare ?? "")\(placemark.thoroughfare != nil ? " " + placemark.thoroughfare! + ", " : "")\(placemark.locality != nil ? placemark.locality! + ", " : "")\(placemark.administrativeArea ?? "") \(placemark.postalCode ?? "")"
            self.parkingLocationAddressLabel.text = address
            self.parkingLocationAddress = address
        }
    }
    
    @IBAction func didTapParkingLocationMore(_ sender: UIButton) {
        if let selectedParkingLocation = getSelectedParkingLocation() {
            var distance = "N/A"
            if let userLocation = locationManager.location {
                let parkingLocationCoordinates = CLLocation(latitude: selectedParkingLocation.latitude, longitude: selectedParkingLocation.longitude)
                distance = "\(String(format: "%.02f", userLocation.distance(from: parkingLocationCoordinates)/metersPerMile))miles"
            }
            
            let parkingLocationDetailsVC = ParkingLocationDetailsTableViewController(nibName: "ParkingLocationDetailsTableViewController", bundle: nil, parkingLocation: selectedParkingLocation, address: parkingLocationAddress ?? "Address not available", distance: distance, time: timeSlider.value)
            parkingLocationDetailsVC.delegate = self
            navigationController?.pushViewController(parkingLocationDetailsVC, animated: true)
        }
    }
    
    @IBAction func didTapParkingLocationPayAndReserve(_ sender: UIButton) {
        if let selectedParkingLocation = getSelectedParkingLocation() {
            let minutes = Int(timeSlider.value)
            let _ = DataProvider.shared.reserveParkingLocation(for: selectedParkingLocation.id, minutes: ReservationRequestMinutes(minutes: minutes), response: { (parkingLocation: ParkingLocation) in
                self.updateParkingLocation(for: parkingLocation)
                self.showSuccessfulReservationAlert(for: parkingLocation)
            }, error: { (error: Error) in
                self.showAlert(with: "Oops", message: "Looks like your reservation did not go through. Please try again.")
            })
        }
    }
    
    func updateParkingLocation(for parkingLocation: ParkingLocation) {
        if let selectedAnnotation = mapView.selectedAnnotations.first {
            if selectedAnnotation is ParkingLocationAnnotation {
                (selectedAnnotation as! ParkingLocationAnnotation).parkingLocation = parkingLocation
                setParkingLocationQuickView(for: parkingLocation)
            }
        }
    }
    
    func showSuccessfulReservationAlert(for parkingLocation: ParkingLocation) {
        let alertController = UIAlertController(title: "Great!", message: "Your reservation has been confirmed.", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        alertController.addAction(closeAction)
        let checkAction = UIAlertAction(title: "Check", style: .default) { (action: UIAlertAction) in
            let reservation = parkingLocation.toJSONString()
            UserDefaults.standard.set(reservation, forKey: reservationKey)
            
            // Switch to reservation tab
            self.tabBarController?.selectedIndex = 1
        }
        alertController.addAction(checkAction)
        alertController.preferredAction = checkAction
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Reservation Delegate
    
    func didReserve(parkingLocation: ParkingLocation) {
        self.updateParkingLocation(for: parkingLocation)
    }
}
