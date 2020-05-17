import Foundation

struct Stats: Decodable {
    let country: String
    let cases: Int
    let deaths: Int
    let recovered: Int
}
