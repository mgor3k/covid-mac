import Foundation

typealias StatsCompletion = (Result<Stats, Error>) -> Void

protocol StatsFetching {
    func fetchData(for country: String, completion: @escaping StatsCompletion)
}

enum FetchError: Error {
    case invalidURL
    case noData
}
