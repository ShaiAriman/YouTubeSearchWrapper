//
//  URLSessionExtension.swift
//
//  Created by Shai Ariman on 27/04/2020.
//  Copyright © 2020 Shai Ariman. All rights reserved.
//

import Foundation

public extension URLSession {
    func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            completionHandler(try? decoder.decode(T.self, from: data), response, nil)
        }
    }
}
