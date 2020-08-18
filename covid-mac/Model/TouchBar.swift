//
//  Copyright © 2020 Maciej Gorecki. All rights reserved.
//

import Cocoa

extension NSTouchBarItem.Identifier {
    static let allCasesItem = NSTouchBarItem.Identifier("covid.allCases")
    static let deathsItem = NSTouchBarItem.Identifier("covid.deaths")
    static let recoveredItem = NSTouchBarItem.Identifier("covid.recovered")
}

extension NSTouchBar.CustomizationIdentifier {
    static let stats = NSTouchBar.CustomizationIdentifier("covid.stats")
}
