//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Maxim on 29.11.2024.
//

import Foundation
class QuestionFactory: QuestionFactoryProtocol{
    
    private weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoading
    private var movies: [MostPopularMovie] = []
    init(moviesLoader: MoviesLoading) {
            self.moviesLoader = moviesLoader
        }
    func requestNextQuestion() {
        DispatchQueue.global().async {[weak self] in
            guard let self = self else { return }
            let index=(0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else {return}
            var imageData=Data()
            
            do {
                imageData = try Data(contentsOf: movie.relizedImageURL)
            }
            catch {
                print("Failed to load image")
            }
            let rating=Float(movie.rating) ?? 0
            let text="Рейтинг этого фильма \nбольше чем 7?"
            let correctAnswer=rating>7
            let question=QuizQuestion(image: imageData, text: text, corretAnswer: correctAnswer)
            DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
                
                    }

        }
    }
    
    func setup(delegate: QuestionFactoryDelegate) {
           self.delegate = delegate
    }
    func loadData() {
            moviesLoader.loadMovies { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result {
                    case .success(let mostPopularMovies):
                        self.movies = mostPopularMovies.items
                        self.delegate?.didLoadDataFromServer()
                    case .failure(let error):
                        self.delegate?.didFailToLoadData(with: error) 
                    }
                }
            }
        }
}
