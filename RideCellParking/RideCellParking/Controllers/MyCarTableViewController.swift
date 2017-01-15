//
//  MyCarTableViewController.swift
//  RideCellParking
//
//  Created by Niklas Fahl on 1/14/17.
//  Copyright © 2017 Niklas Fahl. All rights reserved.
//

import UIKit

class MyCarTableViewController: UITableViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        title = "My Car"
        
        let tabBarImage = UIImage(named: "Car")
        tabBarItem.selectedImage = tabBarImage
        tabBarItem.image = tabBarImage
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
        tableView.register(UINib(nibName: "TwoLabelsTableViewCell", bundle: nil), forCellReuseIdentifier: "TwoLabelsTableViewCell")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // Name
            let cell = tableView.dequeueReusableCell(withIdentifier: "TwoLabelsTableViewCell", for: indexPath) as! TwoLabelsTableViewCell
            
            // Configure the cell...
            cell.setContent(for: "Name", detail: "Niklas Fahl")
            
            return cell
        } else if indexPath.row == 1 {
            // Car
            let cell = tableView.dequeueReusableCell(withIdentifier: "TwoLabelsTableViewCell", for: indexPath) as! TwoLabelsTableViewCell
            
            // Configure the cell...
            cell.setContent(for: "Car", detail: "Ford Fiesta ST")
            
            return cell
        } else if indexPath.row == 2 {
            // Location
            let cell = tableView.dequeueReusableCell(withIdentifier: "TwoLabelsTableViewCell", for: indexPath) as! TwoLabelsTableViewCell
            
            // Configure the cell...
            cell.setContent(for: "Location", detail: "San Francisco, CA")
            
            return cell
        } else if indexPath.row == 3 {
            // Credit Card
            let cell = tableView.dequeueReusableCell(withIdentifier: "TwoLabelsTableViewCell", for: indexPath) as! TwoLabelsTableViewCell
            
            // Configure the cell...
            cell.setContent(for: "Credit Card", detail: "*1234")
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
