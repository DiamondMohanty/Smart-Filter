//
//  DMTableHeaderView.swift
//  Smart Filter
//
//  Created by Diamond Mohanty on 18/07/18.
//  Copyright © 2018 Diamond Mohanty. All rights reserved.
//

import Cocoa

class DMTableHeaderView: NSTableHeaderView {

    private var filteredApplied = false
    var smartWindowController : SmartFilterWindowController = SmartFilterWindowController(windowNibName: "SmartFilterWindowController")
    var delegate: DMTableHeaderViewDelegate?
    var selectedColumn: NSTableColumn?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.smartWindowController.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.smartWindowController.delegate = self
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        if filteredApplied {
            for colNumber in 0..<self.tableView!.numberOfColumns {
                let columnRect = self.headerRect(ofColumn: colNumber)
                let widthOfTheButton: CGFloat = 12.0
                let buttonRect = NSRect(x: (columnRect.origin.x + columnRect.width) - widthOfTheButton - 5.0, y: 2.0, width: widthOfTheButton, height: columnRect.height - 4)
                
                let button = NSButton(frame: buttonRect)
                button.title = ""
                button.image = NSImage(named: "Filter")
                button.imageScaling = .scaleProportionallyDown
                button.imagePosition = .imageOnly
                button.wantsLayer = true
                button.isBordered = false
                button.layer?.backgroundColor = NSColor.white.cgColor
                button.target = self
                button.action = #selector(clickedOnFilterButton(_:))
                self.addSubview(button)
            }
        } else {
            self.subviews.removeAll(keepingCapacity: false)
            self.smartWindowController.window?.close()
        }
    }
    
    @IBAction func clickedOnFilterButton(_ sender: NSButton) {
        let buttonExistAtPoint = NSPoint(x: sender.frame.origin.x, y: sender.frame.origin.y)
        let clickedColumnIndex = self.column(at: buttonExistAtPoint)
        if let tableView = self.tableView, clickedColumnIndex != -1 {
            self.selectedColumn = tableView.tableColumns[clickedColumnIndex]
            let titleOfTheSelectedHeader = selectedColumn!.headerCell.title
            self.showSmartFilter(withTitle: titleOfTheSelectedHeader, andIdentifier: selectedColumn!.identifier)
        }
    }
    
    func showSmartFilter(withTitle title:String, andIdentifier colIdentifier: String) {
        self.smartWindowController.window?.makeKeyAndOrderFront(self)
        if let del = self.delegate, let sourceForFilterTable = del.dataSourceForFilterTable() {
            let columnInfo : [SmartViewColumnInfo: String] = [.identifier: colIdentifier, .title: title]
            self.smartWindowController.initSmartTable(withData: sourceForFilterTable, andColumnInfo: columnInfo)
        }
        
    }
    
    func toggleFilter() {
        self.filteredApplied = !self.filteredApplied
        self.needsDisplay = true
    }
    
}

extension DMTableHeaderView : SmartFilterWindowControllerDelegate {
    func didClickOnApplyFilter(selectedData: [AnyObject]) {
        if let del = self.delegate {
            
            del.didClickOnApplyFilter(selectedArray: selectedData, andIdentifier: self.selectedColumn!.identifier)
        }
    }
}

protocol DMTableHeaderViewDelegate {
    func dataSourceForFilterTable() -> [AnyObject]?
    func didClickOnApplyFilter(selectedArray: [AnyObject], andIdentifier identifier: String)
}
