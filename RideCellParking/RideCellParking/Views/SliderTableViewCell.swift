//
//  SliderTableViewCell.swift
//  RideCellParking
//
//  Created by Niklas Fahl on 1/15/17.
//  Copyright © 2017 Niklas Fahl. All rights reserved.
//

import UIKit

class SliderTableViewCell: UITableViewCell {

    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    var action: (Float) -> Void = {_ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContent(for time: Float, action: @escaping (Float) -> Void) {
        timeSlider.setValue(time, animated: true)
        timeLabel.text = "\(Int(timeSlider.value)) min"
        self.action = action
    }
    
    @IBAction func didChangeTimeSlider(_ sender: UISlider) {
        timeLabel.text = "\(Int(sender.value)) min"
        action(sender.value)
    }
}
