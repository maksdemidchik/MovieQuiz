//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Maxim on 03.01.2025.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate  {
    func didLoadDataFromServer() {
        
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
        
    }
    
    func didFailToLoadData(with error: any Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private weak var viewController: MovieQuizViewController?
    private let statisticService: StatisticServiceProtocol=StatisticService()
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestionIndex: Int = 0
    private var correctAnswer: Int = 0
    init(viewController: MovieQuizViewControllerProtocol=MovieQuizViewController()) {
        self.viewController = viewController as? MovieQuizViewController
            
            questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
            questionFactory?.loadData()
            
        }
    @IBAction func yesButtonClicked() {
         yesNoButtonAction(bool: true)
    }
    
    @IBAction func noButtonClicked() {
        yesNoButtonAction(bool: false)
    }
    
    func yesNoButtonAction(bool: Bool) {
        let myanswer=bool
        viewController?.yesNoModEnabled(bool:false)
        guard let currentQuestion = currentQuestion else { return }
        proceedWithAnswer(isCorrect: myanswer==currentQuestion.corretAnswer)
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let returnQuizStepViewModel=QuizStepViewModel(image:UIImage(data:  model.image) ?? UIImage() , question: model.text, questionNumber: "\(currentQuestionIndex+1)/\(questionsAmount)")
        return returnQuizStepViewModel
    }
    
    func isLastQuestion() -> Bool {
           currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
            currentQuestionIndex = 0
            correctAnswer = 0
            questionFactory?.requestNextQuestion()
    }
    func didAnswer(isCorrectAnswer: Bool) {
            if isCorrectAnswer {
                correctAnswer += 1
            }
        }
    func switchToNextQuestion() {
            currentQuestionIndex += 1
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
                return
            }
            
            currentQuestion = question
            let viewModel = convert(model: question)
            
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.show(quiz: viewModel)
                self?.viewController?.blackBorderColor()
                self?.viewController?.yesNoModEnabled(bool: true)
            }
    }
    
    func proceedWithAnswer(isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect)
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self=self else { return }

            proceedToNextQuestionOrResults()
        }
    }
    
    func proceedToNextQuestionOrResults() {
        if self.isLastQuestion() {
            statisticService.store(correct: correctAnswer , total: questionsAmount)
            let text = correctAnswer == self.questionsAmount ?
                        "Поздравляем, вы ответили на 10 из 10!" :
                        "Вы ответили на \(correctAnswer) из 10, попробуйте ещё раз!"
            let viewModel = QuizResultsViewModel(
                            title: "Этот раунд окончен!",
                            text: text,
                            buttonText: "Сыграть ещё раз")
                           
            viewController?.showAlert(quiz: viewModel)

            
        } else {
            self.switchToNextQuestion()
           
            questionFactory?.requestNextQuestion()
        }
    }
    func makeResultsMessage() -> String {
            statisticService.store(correct: correctAnswer, total: questionsAmount)

            let bestGame = statisticService.bestGame

            let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
            let currentGameResultLine = "Ваш результат: \(correctAnswer)/\(questionsAmount)"
            let bestGameInfoLine = "Рекорд: \(bestGame.correct)/\(bestGame.total)"
            + " (\(bestGame.date.dateTimeString))"
            let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"

            let resultMessage = [
            currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
            ].joined(separator: "\n")

            return resultMessage
    }
    
}
