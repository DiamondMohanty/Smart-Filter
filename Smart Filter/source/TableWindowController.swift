//
//  TableWindowController.swift
//  Smart Filter
//
//  Created by Diamond Mohanty on 18/07/18.
//  Copyright © 2018 Diamond Mohanty. All rights reserved.
//

import Cocoa

class TableWindowController: NSWindowController {

    
    @IBOutlet weak var screenNameTable: NSTableView!
    
    
    var screenDataArray: [[String: Any]] = [[String: Any]]()
    var backupScreenDataArray : [[String: Any]] = [[String: Any]]()
    override func windowDidLoad() {
        super.windowDidLoad()
        
        (self.screenNameTable.headerView as? DMTableHeaderView)?.delegate = self
        
        if let url = Bundle.main.url(forResource: "data", withExtension: "json") {
            let jsonString = try? String.init(contentsOf: url)
            
            if let data = jsonString?.toDictionary() as? [[String: Any]]{
                self.screenDataArray = data
                self.backupScreenDataArray = data
                self.screenNameTable.reloadData()
            }
            
        }
    }
    
    @IBAction func applyFilter(_ sender: Any) {
        
        (self.screenNameTable.headerView as? DMTableHeaderView)?.toggleFilter()
        
    }
    
}

extension TableWindowController: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return screenDataArray.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if let colIdentifier = tableColumn?.identifier {
            return self.screenDataArray[row][colIdentifier]
        }
        
        return nil
        
    }
    
}

extension TableWindowController: DMTableHeaderViewDelegate {
    func dataSourceForFilterTable() -> [AnyObject]? {
        return self.backupScreenDataArray as [AnyObject]
    }
    
    
    func didClickOnApplyFilter(selectedArray: [AnyObject], andIdentifier identifier: String) {
        
        var filteredArray = [[String: Any]]()
        
        for item in selectedArray {
            for model in backupScreenDataArray {
                if model[identifier] as! String == item[identifier] as! String {
                    filteredArray.append(model)
                }
            }
        }
        screenDataArray = filteredArray
        screenNameTable.reloadData()
        
    }
}

extension String {
    func toDictionary() -> Any? {
        if let jsonData = self.data(using: .utf8) {
            let dictionaryLiteral = try? JSONSerialization.jsonObject(with: jsonData, options: [])
            return dictionaryLiteral
        } else {
            return nil
        }
        
    }
}
