//
//  HYFTWindowController.swift
//  covid-mac
//
//  Created by Maciej Gorecki on 16/05/2020.
//  Copyright © 2020 Maciej Gorecki. All rights reserved.
//

import Cocoa

class HYFTWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    override func makeTouchBar() -> NSTouchBar? {
        guard let vc = contentViewController as? CovidViewController else {
            return nil
        }
        return vc.makeTouchBar()
    }

}
