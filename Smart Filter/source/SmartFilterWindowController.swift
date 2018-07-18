//
//  SmartFilterWindowController.swift
//  Smart Filter
//
//  Created by Diamond Mohanty on 18/07/18.
//  Copyright © 2018 Diamond Mohanty. All rights reserved.
//

import Cocoa

enum SmartViewColumnInfo {
    case identifier
    case title
}

class SmartFilterWindowController: NSWindowController {

    @IBOutlet weak var dataTableView: NSTableView!
    var dataSourceForTableView = [[String: Any]]()
    var delegate: SmartFilterWindowControllerDelegate?
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
    }
    
    
    func initSmartTable(withData sentData: [AnyObject], andColumnInfo colInfo: [SmartViewColumnInfo: String]) {
        self.constructTableView(withColumnInfo: colInfo)
        
        var dataArrayWithCheckBoxAttribute = [[String: Any]]()
        for item in uniqueValues(fromDataSource: sentData, andidentifier: colInfo[.identifier]!) {
            let newModel = [
                "selected": 1 as NSNumber,
                colInfo[.identifier]!: item
            ] as [String : Any]
            dataArrayWithCheckBoxAttribute.append(newModel)
        }
        
        
        self.dataSourceForTableView = dataArrayWithCheckBoxAttribute as [[String: Any]]
        dataTableView.reloadData()
    }
    
    func uniqueValues(fromDataSource arr: [AnyObject], andidentifier identifier: String) -> [String] {
        var uniqueValues = Set<String>()
        for item in arr {
            uniqueValues.insert(item.value(forKey: identifier) as! String)
        }
        
        return Array(uniqueValues)
    }
    
    func constructTableView(withColumnInfo columnInfo: [SmartViewColumnInfo: String]) {
        for column in dataTableView.tableColumns.reversed() {
            if column.identifier != "selected" {
                self.dataTableView.removeTableColumn(column)
            }
        }
        
        
        let newTableColumn = NSTableColumn(identifier: columnInfo[.identifier]!)
        newTableColumn.headerCell.title = columnInfo[.title]!
        newTableColumn.width = self.dataTableView.frame.width
        self.dataTableView.addTableColumn(newTableColumn)
    }
    
    @IBAction func closeWindow(_ sender: NSButton) {
        self.window?.close()
    }
    
    @IBAction func enableFilter(_ sender: NSButton) {
        if let del = self.delegate {
            let selectedObjects = dataSourceForTableView.filter({ (model) -> Bool in
                if let value = model["selected"] as? NSNumber {
                    return value == 1
                }
                
                return false
                
            })
            del.didClickOnApplyFilter(selectedData: selectedObjects as [AnyObject])
        }
    }
    
}

extension SmartFilterWindowController: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dataSourceForTableView.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        
        if let colIdentifier = tableColumn?.identifier {
            return dataSourceForTableView[row][colIdentifier]
        }
        return nil
    }
    
    
    func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
        if let identifier = tableColumn?.identifier, identifier == "selected" {
            if let checkBoxValue = object as? NSNumber {
                dataSourceForTableView[row][identifier] = checkBoxValue
            }
        }
        
        tableView.reloadData()
    }
    
    
    
}

protocol SmartFilterWindowControllerDelegate {
    func didClickOnApplyFilter(selectedData: [AnyObject])
}
