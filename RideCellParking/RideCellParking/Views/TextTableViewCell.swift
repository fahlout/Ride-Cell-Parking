//
//  TextTableViewCell.swift
//  RideCellParking
//
//  Created by Niklas Fahl on 1/15/17.
//  Copyright © 2017 Niklas Fahl. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContent(for text: String) {
        textLabel?.text = text
    }
}
