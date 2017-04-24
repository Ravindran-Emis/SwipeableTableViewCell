//
//  AlfaOptionButton.swift
//  AlfaTableCell
//
//  Created by Alfred Reynold on 4/23/17.
//  Copyright © 2017 Alfred Reynold. All rights reserved.
//

import UIKit

typealias ActionBlock = (_ sender:UIButton) -> ()

class AlfaOptionButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var actionBlock:ActionBlock = {(sender) in }
    var originalXvalue:CGFloat = 0
    var optionLabel:UILabel!
    
    func hanldeEvent(event:UIControlEvents, withBlock actionBlock:@escaping ActionBlock) {
        self.actionBlock = actionBlock
        self.addTarget(self, action: #selector(buttonTapped(_:)), for: event)
    }
    
    func buttonTapped(_ sender:UIButton) {
        self.actionBlock(sender)
    }
}
