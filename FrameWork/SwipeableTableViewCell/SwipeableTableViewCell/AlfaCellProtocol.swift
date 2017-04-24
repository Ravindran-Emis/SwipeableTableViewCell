//
//  AlfaCellProtocol.swift
//  AlfaTableCell
//
//  Created by Alfred Reynold on 4/23/17.
//  Copyright © 2017 Alfred Reynold. All rights reserved.
//

import Foundation
import UIKit

protocol AlfaCellProtocol {
    associatedtype Cell:UITableViewCell
    var optionTitles:[String]{get set}
    var optionButtonBGColors:[UIColor]{get set}
    var callBackBlocksforEach:[(_ index:Int)->()]{get set}
    var swipeGestureAdded: Bool{get set}
    var dataIndex:Int {get set}
    var updateTableViewToCloseAllOtherOpenCell:()->() {get set}
    var isIndexPathOpened:Bool {get set}
    func setUp(cell:Cell, cellWidth:CGFloat)
}

extension AlfaCellProtocol {
    
    func getButtonView(text:String, color:UIColor, cell:Cell) -> AlfaOptionButton {
        let view = AlfaOptionButton(frame: CGRect.zero)
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = text
        label.textColor = .white
        let width = label.intrinsicContentSize.width
        view.frame.size.height = cell.frame.height
        view.frame.size.width = width + 50
        
        label.frame.size.width = view.frame.size.width
        label.frame.size.height = view.frame.size.height
        
        label.textAlignment = .center
        view.backgroundColor = color
        view.optionLabel = label
        view.addSubview(label)
        
        return view
    }
    
    func optionButtonTapped(_ button:UIButton) {
        if button.tag < self.callBackBlocksforEach.count {
            self.callBackBlocksforEach[button.tag](dataIndex)
        }
    }
    
    func setUp(cell:Cell, cellWidth:CGFloat) {
        var buttonViews = [AlfaOptionButton]()
        
        var endValue = cellWidth
        var buts = getButtons(cell: cell)
        var resuseButtons = false
        if buts.count == optionTitles.count {
            resuseButtons = true
            buts.sort(by: { (button1, button2) -> Bool in
                return button1.tag > button2.tag
            })
            buttonViews = buts
        } else {
            buts.forEach({ (but) in
                but.removeFromSuperview()
            })
        }
        
        for index in stride(from: optionTitles.count - 1, through: 0, by: -1) {
            let title = optionTitles[index]
            var color = UIColor.white
            if index < optionButtonBGColors.count {
                color = optionButtonBGColors[index]
            }
            var button:AlfaOptionButton!
            if resuseButtons {
                button = buts[index]
            } else {
                button = self.getButtonView(text: title, color:color, cell: cell)
                button.tag = index
                button.hanldeEvent(event: .touchUpInside, withBlock: { (button) in
                    self.optionButtonTapped(button)
                })
                buttonViews.append(button)
                cell.addSubview(button)
                cell.sendSubview(toBack: button)
            }
        }
        
        buttonViews = Array(buttonViews.reversed())
        var displacement:CGFloat = 0
        for but in buttonViews {
            but.frame.origin.x = endValue
            but.originalXvalue = but.frame.origin.x
            endValue += but.frame.width
            displacement += but.frame.width
        }
        
        var swipeLeft:AlfaSwipeGestureRecogniser!
        var swipeRight:AlfaSwipeGestureRecogniser!
        
        if cell.gestureRecognizers == nil || cell.gestureRecognizers?.count == 0 {
            swipeLeft = AlfaSwipeGestureRecogniser(for: cell) { (recogniser) in
                self.swipeLeft(cell: cell, gestureRecogniser: recogniser)
            }
            swipeLeft.direction = .left
            swipeRight = AlfaSwipeGestureRecogniser(for: cell) { (recogniser) in
                self.swipeRight(cell: cell, gestureRecogniser: recogniser)
            }
            swipeRight.direction = .right
        } else if let recogs = cell.gestureRecognizers as? [AlfaSwipeGestureRecogniser] {
            for recog in recogs {
                if recog.direction == .left {
                    swipeLeft = recog
                } else if recog.direction == .right {
                    swipeRight = recog
                }
            }
        }
        
        if isIndexPathOpened {
            cell.contentView.frame.origin.x = -displacement
            for but in buttonViews {
                but.frame.origin.x -= displacement
            }
            swipeLeft.swiped = true
            swipeRight.swiped = false
        } else {
            cell.contentView.frame.origin.x = 0
            for but in buts {
                but.frame.origin.x = but.originalXvalue
            }
            swipeLeft.swiped = false
            swipeRight.swiped = true
        }
        
    }
    
    func getSpaceOccupiedButtons(cell:Cell) -> CGFloat {
        var space:CGFloat = 0
        for view in cell.subviews {
            if let but = view as? AlfaOptionButton {
                space += but.frame.width
            }
        }
        return space
    }
    
    func getButtons(cell:Cell) -> [AlfaOptionButton] {
        var buts:[AlfaOptionButton] = []
        for view in cell.subviews {
            if let but = view as? AlfaOptionButton {
                buts.append(but)
            }
        }
        return buts
    }
    
    func toggleCellOpenClose (toOpen:Bool, cell:Cell, recogniser:UISwipeGestureRecognizer) {
        
        guard let alfaRecogniser = recogniser as? AlfaSwipeGestureRecogniser else { return }
        let displacement = getSpaceOccupiedButtons(cell: cell)
        let buts = getButtons(cell: cell)
        UIView.animate(withDuration: 0.3, animations: {
            if recogniser.direction == .left && !alfaRecogniser.swiped {
                //Open
                cell.contentView.frame.origin.x = -displacement
                for but in buts {
                    but.frame.origin.x -= displacement
                }
                
            } else if recogniser.direction == .right && !alfaRecogniser.swiped  {
                //Close
                cell.contentView.frame.origin.x = 0
                for but in buts {
                    but.frame.origin.x = but.originalXvalue
                }
            }
        }, completion: { (done) in

            if let recogs = cell.gestureRecognizers as? [AlfaSwipeGestureRecogniser] {
                for recog in recogs {
                    if recog == alfaRecogniser {
                        recog.swiped = true
                        continue
                    }
                    recog.swiped = false
                }
            }
        })
        
    }
    
    func closeCell (cell:Cell) {
        let buts = getButtons(cell: cell)
        UIView.animate(withDuration: 0.2, animations: { 
            cell.contentView.frame.origin.x = 0
            for but in buts {
                but.frame.origin.x = but.originalXvalue
            }
        }) { (done) in
            if let recogs = cell.gestureRecognizers as? [AlfaSwipeGestureRecogniser] {
                for recog in recogs {
                    if recog.direction == .right {
                        recog.swiped = true
                        continue
                    }
                    recog.swiped = false
                }
            }
        }
    }
    
    func swipeLeft(cell:Cell, gestureRecogniser:UISwipeGestureRecognizer?) {
        updateTableViewToCloseAllOtherOpenCell()
        self.toggleCellOpenClose(toOpen:true, cell: cell, recogniser: gestureRecogniser!)
    }
    
    func swipeRight(cell:Cell, gestureRecogniser:UISwipeGestureRecognizer?) {
        self.toggleCellOpenClose(toOpen:false, cell: cell, recogniser: gestureRecogniser!)
    }
}





