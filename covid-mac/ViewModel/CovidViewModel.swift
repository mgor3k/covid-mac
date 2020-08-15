//
//  Copyright © 2020 Maciej Gorecki. All rights reserved.
//

import Foundation

class CovidViewModel {
    private let api: StatsFetching = Coronavirus19herokuFetcher(session: URLSession.shared)
    
    private(set) var country = ""
    var stats: Stats?
    
    func fetchStats(country: String, completion: @escaping StatsCompletion) {
        self.country = country
        
        api.fetchData(for: country) { [weak self] result in
            switch result {
            case .success(let stats):
                self?.stats = stats
            case .failure(let error):
                self?.stats = nil
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
