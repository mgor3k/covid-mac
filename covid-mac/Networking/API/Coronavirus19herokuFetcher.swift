//
//  Copyright © 2020 Maciej Gorecki. All rights reserved.
//

import Foundation
import os.log

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
                error.log()
                completion(.failure(error))
                return
            }
            
            let decoder = JSONDecoder()
            guard let data = data else {
                let error = FetchError.dataMissing
                error.log()
                completion(.failure(error))
                return
            }
            
            do {
                let stats = try decoder.decode(Stats.self, from: data)
                completion(.success(stats))
            } catch {
                if let stringError = String(data: data, encoding: .utf8) {
                    let error = FetchError.custom(stringError)
                    error.log()
                    completion(.failure(error))
                } else {
                    error.log()
                    completion(.failure(error))
                }
            }
            
        }
        
        dataTask.resume()
    }
}

private extension Error {
    func log() {
        os_log(
            "%{public}@",
            log: OSLog.networking,
            type: .error,
            self.localizedDescription
        )
    }
}
