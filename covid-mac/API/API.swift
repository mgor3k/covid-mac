import Foundation

class API {
    private let baseURL: String = "https://coronavirus-19-api.herokuapp.com/"
}

extension API: StatsFetching {
    func fetchData(for country: String, completion: @escaping StatsCompletion) {
        let path = "countries/\(country)"
        guard let url = URL(string: baseURL + path) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let decoder = JSONDecoder()
            guard let data = data else {
                completion(.failure(APIError.noData))
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
