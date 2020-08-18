//
//  Copyright © 2020 Maciej Gorecki. All rights reserved.
//

import Foundation

enum FetchError: LocalizedError {
    case invalidURL
    case dataMissing
    case custom(String)
    
    var errorDescription: String? {
        switch self {
        case .dataMissing, .invalidURL:
            return "API server error"
        case .custom(let message):
            return message
        }
    }
}
