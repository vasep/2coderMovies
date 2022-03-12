//
//  ApiManager.swift
//  2coderMovies
//
//  Created by Vasil Panov on 11.3.22.
//

import Foundation

enum Result<T, U> {
    case success(T)
    case failure(U)
}

class ApiManager {
    static let shared = ApiManager()
    var isPaginating = false
    func fetchMoviesList(pagination:Bool, page:Int, completion: @escaping (Result<MoveBaseResponse, Error>) -> Void) {
        let baseUrl = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=9a4bb69b2463e5003d7f09856d08edab&page=\(page)")!

        if pagination {
            isPaginating = true
        }
        
        HTTPManager.shared.get(baseUrl) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async { completion(.failure(error)) }
                self.isPaginating = false
            case .success(let data):
                let decoder = JSONDecoder()
                self.isPaginating = false

                do {
                    let breaches = try decoder.decode(MoveBaseResponse.self, from: data)
                    DispatchQueue.main.async { completion(.success(breaches)) }
                } catch {
                    print(String(data: data, encoding: .utf8) ?? "Unable to retrieve string representation")
                    DispatchQueue.main.async { completion(.failure(error)) }
                }
            }
        }
    }
}
