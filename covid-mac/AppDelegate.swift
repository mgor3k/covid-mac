//
//  AppDelegate.swift
//  covid-mac
//
//  Created by Maciej Gorecki on 16/05/2020.
//  Copyright © 2020 Maciej Gorecki. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusBarItem: NSStatusItem!
    var api: StatsFetching!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        api = API()
        
        if #available(OSX 10.12.2, *) {
            NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true
        }
        
        let statusBar = NSStatusBar.system
        statusBarItem = statusBar.statusItem(withLength: NSStatusItem.squareLength)
        statusBarItem.button?.title = "☝️"
        statusBarItem.button?.target = self
        statusBarItem.button?.action = #selector(statusBarTapped)
        statusBarItem.button?.sendAction(on: .leftMouseUp)
        
        let statusBarMenu = NSMenu(title: "lel menu")
//        statusBarItem.menu = statusBarMenu
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func statusBarTapped() {
        NSApplication.shared.activate(ignoringOtherApps: true)
    }


}

