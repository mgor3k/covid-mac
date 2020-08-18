//
//  Copyright © 2020 Maciej Gorecki. All rights reserved.
//

import Foundation

class CovidViewModel {
    private let api: StatsFetching = Coronavirus19herokuFetcher(session: URLSession.shared)
    private var country = "Poland"
    private(set) var stats: Stats?
    private var timer: Timer?
    
    var statsDidUpdate: StatsCompletion?
}

extension CovidViewModel {
    var countryName: String {
        country.capitalizingFirstLetter()
    }
    
    func setCountry(_ country: String) {
        self.country = country
    }
    
    func fetchStats() {
        timer?.invalidate()
        
        fetch()
        timer = Timer.scheduledTimer(
            withTimeInterval: 60 * 60,
            repeats: true)
        { [weak self] timer in
            self?.fetch()
        }
    }
}

private extension CovidViewModel {
    func fetch() {
        api.fetchData(for: country) { [weak self] result in
            switch result {
            case .success(let stats):
                self?.stats = stats
            case .failure:
                self?.stats = nil
            }
            DispatchQueue.main.async {
                self?.statsDidUpdate?(result)
            }
        }
    }
}
