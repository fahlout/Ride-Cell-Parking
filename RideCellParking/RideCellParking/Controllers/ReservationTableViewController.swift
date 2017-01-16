//
//  ReservationTableViewController.swift
//  RideCellParking
//
//  Created by Niklas Fahl on 1/14/17.
//  Copyright © 2017 Niklas Fahl. All rights reserved.
//

import UIKit
import MapKit

let reservationKey = "RESERVATION_KEY"
let reservationStartTimeKey = "RESERVATION_START_TIME_KEY"

class ReservationTableViewController: UITableViewController {
    
    let geocoder = CLGeocoder()
    
    var reservation: ParkingLocation?
    var parkingLocationAddress: String = ""
    var isReservationOver = false
    var extensionTime: Float = 10.0
    var timer: Timer?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        title = "Reservation"
        
        let tabBarImage = UIImage(named: "Reservation")
        tabBarItem.selectedImage = tabBarImage
        tabBarItem.image = tabBarImage
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNavigationBarButtons()
        registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateReservationReference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerCells() {
        tableView.register(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleTableViewCell")
        tableView.register(UINib(nibName: "TextTableViewCell", bundle: nil), forCellReuseIdentifier: "TextTableViewCell")
        tableView.register(UINib(nibName: "TwoLabelsTableViewCell", bundle: nil), forCellReuseIdentifier: "TwoLabelsTableViewCell")
        tableView.register(UINib(nibName: "SliderTableViewCell", bundle: nil), forCellReuseIdentifier: "SliderTableViewCell")
        tableView.register(UINib(nibName: "ButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "ButtonTableViewCell")
    }
    
    func updateReservationReference() {
        reservation = getReservation()
        if reservation != nil {
            setParkingLocationAddress(for: reservation!)
            isReservationOver = Date() > reservation!.reservedUntil
            if !isReservationOver {
                startTimer()
            }
            
            tableView.reloadData()
        }
    }
    
    func getReservation() -> ParkingLocation? {
        let reservationJSON = UserDefaults.standard.string(forKey: reservationKey)
        if let reservation = Mapper<ParkingLocation>().map(JSONString: reservationJSON ?? "") {
            return reservation
        } else {
            return nil
        }
    }
    
    func getReservationStartTime() -> Date? {
        return UserDefaults.standard.object(forKey: reservationStartTimeKey) as? Date
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if reservation != nil && isReservationOver {
            return 2
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reservation != nil {
            if isReservationOver {
                if section == 0 {
                    return 4
                } else {
                    return 5
                }
            } else {
                return 4
            }
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return isReservationOver ? "Reservation Summary" : "Reservation Details"
        } else if section == 1 {
            return "Edit Reservation"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 1 {
            return 94.0
        }
        return 44.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as! TitleTableViewCell
                
                // Configure the cell...
                guard let reservation = reservation else {
                    cell.setContent(for: "No reservation found.")
                    return cell
                }
                
                cell.setContent(for: reservation.name)
                
                return cell
            } else if indexPath.row == 1 {
                // Location Name
                let cell = tableView.dequeueReusableCell(withIdentifier: "TwoLabelsTableViewCell", for: indexPath) as! TwoLabelsTableViewCell
                
                // Configure the cell...
                cell.setContent(for: "Address", detail: parkingLocationAddress)
                
                return cell
            } else if indexPath.row == 2 {
                // Location Address
                let cell = tableView.dequeueReusableCell(withIdentifier: "TwoLabelsTableViewCell", for: indexPath) as! TwoLabelsTableViewCell
                
                // Configure the cell...
                cell.setContent(for: "Cost", detail: "$\(String(format: "%.02f", cost()))")
                
                return cell
            } else if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell", for: indexPath) as! ButtonTableViewCell
                
                // Configure the cell...
                cell.setContent(for: "Directions to car", enabled: true, action: { 
                    self.getDirectionsToCar()
                })
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath) as! TextTableViewCell
                
                // Configure the cell...
                cell.setContent(for: "Extend By")
                
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SliderTableViewCell", for: indexPath) as! SliderTableViewCell
                
                // Configure the cell...
                cell.setContent(for: extensionTime, action: { (time: Float) in
                    self.extensionTime = time
                    self.tableView.reloadData()
                })
                
                return cell
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TwoLabelsTableViewCell", for: indexPath) as! TwoLabelsTableViewCell
                
                // Configure the cell...
                cell.setContent(for: "Cost", detail: "$\(String(format: "%.02f", costToExtend()))")
                
                return cell
            } else if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell", for: indexPath) as! ButtonTableViewCell
                
                // Configure the cell...
                cell.setContent(for: "Extend Reservation", enabled: true, action: {
                    self.extendReservation()
                })
                
                return cell
            } else if indexPath.row == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell", for: indexPath) as! ButtonTableViewCell
                
                // Configure the cell...
                cell.setContent(for: "Delete Reservation", enabled: true, action: {
                    self.deleteReservation()
                })
                
                return cell
            } else {
                return UITableViewCell()
            }
        }
    }
}

extension ReservationTableViewController {
    
    // MARK: - Reservation Edit
    
    func extendReservation() {
        guard let reservation = reservation else {
            self.showAlert(with: "Oops", message: "Your reservation could not be extended at this time. Please try again.")
            return
        }
        
        let _ = DataProvider.shared.resetParkingLocation(for: reservation.id, response: { (parkingLocation: ParkingLocation) in
            let _ = DataProvider.shared.reserveParkingLocation(for: reservation.id, minutes: ReservationRequestMinutes(minutes: Int(self.extensionTime)), response: { (parkingLocation: ParkingLocation) in
                UserDefaults.standard.set(parkingLocation.toJSONString(), forKey: reservationKey)
                UserDefaults.standard.set(Date(), forKey: reservationStartTimeKey)
                self.updateReservationReference()
                self.showAlert(with: "Great!", message: "Your reservation extension has been confirmed.")
            }, error: { (error: Error) in
                self.showAlert(with: "Oops", message: "Your reservation could not be extended at this time. Please try again.")
            })
        }) { (error: Error) in
            self.showAlert(with: "Oops", message: "Your reservation could not be extended at this time. Please try again.")
        }
    }
    
    func deleteReservation() {
        guard let reservation = reservation else {
            self.showAlert(with: "Oops", message: "Your reservation could not be deleted at this time. Please try again.")
            return
        }
        
        let _ = DataProvider.shared.resetParkingLocation(for: reservation.id, response: { (parkingLocation:ParkingLocation) in
            UserDefaults.standard.removeObject(forKey: reservationKey)
            UserDefaults.standard.removeObject(forKey: reservationStartTimeKey)
            self.reservation = nil
            self.tableView.reloadData()
        }) { (error: Error) in
            self.showAlert(with: "Oops", message: "Your reservation could not be deleted at this time. Please try again.")
        }
    }
}

extension ReservationTableViewController {
    
    // MARK: - Timer
    func startTimer() {
        if let reservation = reservation {
            timer?.stop()
            timer = 1.second.interval(block: { (timer: Timer) in
                self.isReservationOver = Date() > reservation.reservedUntil
                if self.isReservationOver {
                    timer.stop()
                    self.title = "Reservation"
                    self.tableView.reloadData()
                    return
                }
                
                self.title = self.timeLeft(for: reservation)
            })
        }
    }
    
    func timeLeft(for reservation: ParkingLocation) -> String {
        let totalSeconds = Double(reservation.reservedUntil.seconds(from: Date()))
        let minutes = Int(floor(totalSeconds / 60.0))
        let seconds = Int(totalSeconds - Double(minutes) * 60.0)
        return "\(minutes):\(seconds < 10 ? "0" + "\(seconds)" : "\(seconds)")"
    }
}

extension ReservationTableViewController {
    
    // MARK: - Cost
    
    func cost() -> Double {
        guard let reservationStartTime = UserDefaults.standard.object(forKey: reservationStartTimeKey) as? Date else {
            return 0.0
        }
        guard let reservation = reservation else {
            return 0.0
        }
        let minutes = ceil(Double(reservation.reservedUntil.seconds(from: reservationStartTime)) / 60.0)
        
        return Double(minutes) * reservation.costPerMinute
    }
    
    func costToExtend() -> Double {
        guard let reservation = reservation else {
            return 0.0
        }
        return Double(Int(extensionTime)) * reservation.costPerMinute
    }
}

extension ReservationTableViewController {
    
    // MARK: - Address
    
    func setParkingLocationAddress(for parkingLocation: ParkingLocation) {
        let parkingLocationCoordinates = CLLocation(latitude: parkingLocation.latitude, longitude: parkingLocation.longitude)
        geocoder.reverseGeocodeLocation(parkingLocationCoordinates) { (placemarks: [CLPlacemark]?, error: Error?) in
            guard let placemark = placemarks?[0] else {
                self.parkingLocationAddress = "Address not available"
                self.tableView.reloadData()
                return
            }
            
            let address = "\(placemark.subThoroughfare ?? "")\(placemark.thoroughfare != nil ? " " + placemark.thoroughfare! + ", " : "")\(placemark.locality != nil ? placemark.locality! + ", " : "")\(placemark.administrativeArea ?? "") \(placemark.postalCode ?? "")"
            self.parkingLocationAddress = address
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Directions in maps
    
    func getDirectionsToCar() {
        guard let reservation = reservation else {
            return
        }
        
        let coordinates = CLLocationCoordinate2D(latitude: reservation.latitude, longitude: reservation.longitude)
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Car parked at \(reservation.name)"
        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
}

extension ReservationTableViewController {
    
    // MARK: - Navigation Bar Setup
    
    func addNavigationBarButtons() {
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshBarButtonAction))
        navigationItem.rightBarButtonItem = refreshButton
    }
    
    // MARK: - Refresh Bar Button Action
    func refreshBarButtonAction() {
        reservation = getReservation()
        tableView.reloadData()
    }
}
