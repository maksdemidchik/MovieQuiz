//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Maxim on 20.12.2024.
//

import Foundation
protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}
struct MoviesLoader: MoviesLoading {
    private let networkClient: NetworkRouting
    init(networkClient: NetworkRouting=NetworkClient()) {
        self.networkClient = networkClient
    }
    private var mostPopularMoviesUrl: URL {
            guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
                preconditionFailure("Unable to construct mostPopularMoviesUrl")
            }
            return url
        }
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result{
            case .success(let data):
                do {
                    let MostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(MostPopularMovies))
                }
                catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
            
        }
        
        
    
    }
}
