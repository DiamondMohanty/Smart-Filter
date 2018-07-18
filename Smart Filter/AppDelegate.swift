//
//  AppDelegate.swift
//  Smart Filter
//
//  Created by Diamond Mohanty on 18/07/18.
//  Copyright © 2018 Diamond Mohanty. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    var tableViewWindowController: TableWindowController?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if tableViewWindowController == nil {
            tableViewWindowController = TableWindowController(windowNibName: "TableWindowController")
            tableViewWindowController?.window?.makeKeyAndOrderFront(self)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        
    }

    @IBAction func applyFilter(_ sender: Any) {
        
    }
    
}

