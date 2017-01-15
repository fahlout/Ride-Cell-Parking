//
//  ParkingLocationDetailsTableViewController.swift
//  RideCellParking
//
//  Created by Niklas Fahl on 1/15/17.
//  Copyright © 2017 Niklas Fahl. All rights reserved.
//

import UIKit

protocol ReservationDelegate {
    func didReserve(parkingLocation: ParkingLocation)
}

class ParkingLocationDetailsTableViewController: UITableViewController {
    
    var parkingLocation: ParkingLocation!
    var parkingLocationAddress: String!
    var parkingLocationDistance: String!
    var reservationTime: Float!
    
    var delegate: ReservationDelegate?
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, parkingLocation: ParkingLocation, address: String, distance: String, time: Float) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        title = "Parking Location"
        
        self.parkingLocation = parkingLocation
        self.parkingLocationAddress = address
        self.parkingLocationDistance = distance
        self.reservationTime = time
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 {
            return 94.0
        }
        return 44.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // Parking Location Title
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as! TitleTableViewCell
            
            // Configure the cell...
            cell.setContent(for: parkingLocation.name)
            
            return cell
        } else if indexPath.row == 1 {
            // Parking Location Address
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath) as! TextTableViewCell
            
            // Configure the cell...
            cell.setContent(for: parkingLocationAddress)
            
            return cell
        } else if indexPath.row == 2 {
            // Parking Location Cost
            let cell = tableView.dequeueReusableCell(withIdentifier: "TwoLabelsTableViewCell", for: indexPath) as! TwoLabelsTableViewCell
            
            // Configure the cell...
            cell.setContent(for: "Cost", detail: "$\(String(format: "%.02f", parkingLocation.costPerMinute))/min")
            
            return cell
        } else if indexPath.row == 3 {
            // Parking Location Distance
            let cell = tableView.dequeueReusableCell(withIdentifier: "TwoLabelsTableViewCell", for: indexPath) as! TwoLabelsTableViewCell
            
            // Configure the cell...
            cell.setContent(for: "Distance", detail: parkingLocationDistance)
            
            return cell
        } else if indexPath.row == 4 {
            // Parking Location Time Slider
            let cell = tableView.dequeueReusableCell(withIdentifier: "SliderTableViewCell", for: indexPath) as! SliderTableViewCell
            
            // Configure the cell...
            cell.setContent(for: reservationTime, action: { (time: Float) in
                self.reservationTime = time
            })
            
            return cell
        } else if indexPath.row == 5 {
            // Parking Location Reserve Button
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell", for: indexPath) as! ButtonTableViewCell
            
            // Configure the cell...
            if parkingLocation.isReserved {
                cell.setContent(for: "Reserved", enabled: false, action: nil)
            } else {
                cell.setContent(for: "Reserve and Pay", enabled: true, action: {
                    let _ = DataProvider.shared.reserveParkingLocation(for: self.parkingLocation.id, minutes: ReservationRequestMinutes(minutes: Int(self.reservationTime)), response: { (parkingLocation: ParkingLocation) in
                        self.parkingLocation = parkingLocation
                        self.showSuccessfulReservationAlert(for: parkingLocation)
                        self.delegate?.didReserve(parkingLocation: parkingLocation)
                        self.tableView.reloadData()
                    }, error: { (error: Error) in
                        self.showAlert(with: "Oops", message: "Looks like your reservation did not go through. Please try again.")
                    })
                })
            }
            
            return cell
        } else {
            return UITableViewCell()
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
}
