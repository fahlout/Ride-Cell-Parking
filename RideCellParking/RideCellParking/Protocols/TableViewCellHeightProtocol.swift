//
//  TableViewCellHeightProtocol.swift
//  RideCellParking
//
//  Created by Niklas Fahl on 1/15/17.
//  Copyright © 2017 Niklas Fahl. All rights reserved.
//

import UIKit

protocol TableViewCellHeightProtocol {
    func preferredHeight() -> CGFloat
}

extension UITableViewCell: TableViewCellHeightProtocol {
    func preferredHeight() -> CGFloat {
        return 44.0
    }
}

