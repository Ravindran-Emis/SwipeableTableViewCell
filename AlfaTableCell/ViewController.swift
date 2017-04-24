//
//  ViewController.swift
//  AlfaTableCell
//
//  Created by Alfred Reynold on 4/23/17.
//  Copyright © 2017 Alfred Reynold. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let nib = UINib(nibName: "AlfaTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "ALFA")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func info(index:Int) {
        print("info \(index)")
    }
    
    func delete(index:Int) {
        print("delete \(index)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return 200
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ALFA") as? AlfaTableViewCell else { return  UITableViewCell(style: .default, reuseIdentifier: "ALFA")}
        
        cell.optionTitles = ["Info","Delete"]
        cell.optionButtonBGColors = [.lightGray, .red]
        let infoBlock = {(index:Int) in
            self.info(index: index)
        }
        let deleteBlock = {(index:Int) in
            self.delete(index: index)
        }
        cell.callBackBlocksforEach = [infoBlock, deleteBlock]
        cell.dataIndex = indexPath.row
        cell.setUp(cell: cell, cellWidth: self.tableView.bounds.width)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

