//
//  HTTPManager.swift
//  2coderMovies
//
//  Created by Vasil Panov on 11.3.22.
//

import Foundation

class HTTPManager {
    static let shared = HTTPManager()

    enum HTTPError: Error {
        case invalidResponse(Data?, URLResponse?)
    }

    public func get(_ url: URL, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completionBlock(.failure(error!))
                return
            }

            guard
                let responseData = data,
                let httpResponse = response as? HTTPURLResponse,
                200 ..< 300 ~= httpResponse.statusCode else {
                    completionBlock(.failure(HTTPError.invalidResponse(data, response)))
                    return
            }

            completionBlock(.success(responseData))
        }
        task.resume()
    }
}
