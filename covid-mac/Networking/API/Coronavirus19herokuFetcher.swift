//
//  Copyright © 2020 Maciej Gorecki. All rights reserved.
//

import Foundation

class Coronavirus19herokuFetcher: StatsFetching {
    private let baseURL: String = "https://coronavirus-19-api.herokuapp.com/"
    private let session: Session
    
    init(session: Session) {
        self.session = session
    }

    func fetchData(for country: String, completion: @escaping StatsCompletion) {
        let path = "countries/\(country)"
        guard let url = URL(string: baseURL + path) else {
            completion(.failure(FetchError.invalidURL))
            return
        }
        
        let dataTask = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let decoder = JSONDecoder()
            guard let data = data else {
                completion(.failure(FetchError.noData))
                return
            }
            
            do {
                let stats = try decoder.decode(Stats.self, from: data)
                completion(.success(stats))
            } catch {
                completion(.failure(error))
            }
            
        }
        
        dataTask.resume()
    }
}
