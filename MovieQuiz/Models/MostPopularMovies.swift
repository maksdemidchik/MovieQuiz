//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Maxim on 20.12.2024.
//

import Foundation
struct MostPopularMovies:Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}
struct MostPopularMovie:Codable {
    let title: String
    let rating: String
    let imageURL: URL
    var relizedImageURL: URL {
        let urlString = imageURL.absoluteString
        let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        guard let newURL = URL(string: imageUrlString) else {
                    return imageURL
                }
                
                return newURL
    }
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating="imDbRating"
        case imageURL = "image"
    }
}