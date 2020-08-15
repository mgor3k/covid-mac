//
//  Copyright © 2020 Maciej Gorecki. All rights reserved.
//

import Foundation

class CovidViewModel {
    private let api: StatsFetching = Coronavirus19herokuFetcher(session: URLSession.shared)
    private var country = "Poland"
    private(set) var stats: Stats?
}

extension CovidViewModel {
    var countryName: String {
        country.capitalizingFirstLetter()
    }
    
    func setCountry(_ country: String) {
        self.country = country
    }
    
    func fetchStats(completion: @escaping StatsCompletion) {
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
