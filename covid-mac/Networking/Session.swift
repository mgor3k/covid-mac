//
//  Copyright © 2020 Maciej Gorecki. All rights reserved.
//

import Foundation

protocol Session {
    func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: Session {}
