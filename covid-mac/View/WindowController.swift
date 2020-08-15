//
//  Copyright © 2020 Maciej Gorecki. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    override func makeTouchBar() -> NSTouchBar? {
        (contentViewController as? CovidViewController)?.makeTouchBar()
    }
}
