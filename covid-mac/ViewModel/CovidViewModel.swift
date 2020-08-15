//
//  Copyright © 2020 Maciej Gorecki. All rights reserved.
//

import Foundation

class CovidViewModel {
    private let api: StatsFetching = Coronavirus19herokuFetcher(session: URLSession.shared)
    var stats: Stats?
    
    func fetchStats(completion: @escaping StatsCompletion) {
        api.fetchData(for: "Poland") { [weak self] result in
            switch result {
            case .success(let stats):
                self?.stats = stats
            case .failure(let error):
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
