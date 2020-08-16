//
//  Copyright © 2020 Maciej Gorecki. All rights reserved.
//

import Foundation
import os.log

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    static let networking = OSLog(subsystem: subsystem, category: "networking")
}
