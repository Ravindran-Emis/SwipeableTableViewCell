//
//  AlfaTableViewCell.swift
//  AlfaTableCell
//
//  Created by Alfred Reynold on 4/23/17.
//  Copyright © 2017 Alfred Reynold. All rights reserved.
//

import UIKit
import SwipeableTableViewCell

class AlfaTableViewCell: UITableViewCell,AlfaCellProtocol {
    
    var isIndexPathOpened: Bool = false

    var updateTableViewToCloseAllOtherOpenCell: () -> () = {() in}

    var dataIndex: Int = 0

    var swipeGestureAdded: Bool = false

    var callBackBlocksforEach: [(Int) -> ()] = []

    var optionButtonBGColors: [UIColor] = []

    var optionTitles: [String] = []

    typealias Cell = UITableViewCell


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
