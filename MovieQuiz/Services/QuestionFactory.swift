//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Maxim on 29.11.2024.
//

import Foundation
class QuestionFactory: QuestionFactoryProtocol{
    weak var delegate: QuestionFactoryDelegate?
    private let questions: [QuizQuestion]=[QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма \nбольше чем 6?", corretAnswer: true),QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма \nбольше чем 6?", corretAnswer: true),QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма \nбольше чем 6?", corretAnswer: true),QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма \nбольше чем 6?", corretAnswer: true),QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма \nбольше чем 6?", corretAnswer: true),QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма \nбольше чем 6?", corretAnswer: true),QuizQuestion(image: "Old", text: "Рейтинг этого фильма \nбольше чем 6?", corretAnswer: false),QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма \nбольше чем 6?", corretAnswer: false),QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма \nбольше чем 6?", corretAnswer: false),QuizQuestion(image:"Vivarium", text: "Рейтинг этого фильма \nбольше чем 6?", corretAnswer: false)]
    func requestNextQuestion() {
        guard let index = (0..<questions.count).randomElement()  else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        let question = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: question)
    }
    func setup(delegate: QuestionFactoryDelegate) {
           self.delegate = delegate
       }
}
