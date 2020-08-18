//
//  Copyright © 2020 Maciej Gorecki. All rights reserved.
//

import Foundation

typealias StatsCompletion = (Result<Stats, Error>) -> Void

protocol StatsFetching {
    func fetchData(for country: String, completion: @escaping StatsCompletion)
}
