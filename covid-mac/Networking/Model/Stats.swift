//
//  Copyright © 2020 Maciej Gorecki. All rights reserved.
//

import Foundation

struct Stats: Decodable {
    let country: String
    let cases: Int
    let deaths: Int
    let recovered: Int
}
