//
//  ButtonTableViewCell.swift
//  RideCellParking
//
//  Created by Niklas Fahl on 1/15/17.
//  Copyright © 2017 Niklas Fahl. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var button: UIButton!
    var action: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContent(for title: String, enabled: Bool, action: (() -> Void)?) {
        button.setTitle(title, for: .normal)
        self.action = action
        
        if enabled {
            button.backgroundColor = .rideCellBlue
        } else {
            button.backgroundColor = .gray
        }
        button.isEnabled = enabled
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        action?()
    }
}
