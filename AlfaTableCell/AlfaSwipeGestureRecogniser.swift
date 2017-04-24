//
//  AlfaSwipeGestureRecogniser.swift
//  AlfaTableCell
//
//  Created by Alfred Reynold on 4/23/17.
//  Copyright © 2017 Alfred Reynold. All rights reserved.
//

import UIKit

typealias SwipeActionBlock = (_ recognizer:UISwipeGestureRecognizer) -> ()

class AlfaSwipeGestureRecogniser: UISwipeGestureRecognizer {
    
    private var swipeAction:SwipeActionBlock = {(recognizer) in }
    var swiped:Bool = false
    
    init() {
        super.init(target: AlfaSwipeGestureRecogniser.self, action: #selector(self.swipeDetected(_:)))
        self.removeTarget(AlfaSwipeGestureRecogniser.self, action: #selector(self.swipeDetected(_:)))
        self.addTarget(self, action: #selector(self.swipeDetected(_:)))
    }
    
    convenience init(for view: UIView, block: @escaping SwipeActionBlock) {
        self.init()
        swipeAction = block
        view.addGestureRecognizer(self)
    }
    
    func swipeDetected(_ recognizer:UISwipeGestureRecognizer) {
        self.swipeAction(recognizer)
    }
}
