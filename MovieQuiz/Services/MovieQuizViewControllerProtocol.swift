//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Maxim on 08.01.2025.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func showLoadingIndicator()
    
    func showNetworkError(message: String)
    
    func show(quiz step: QuizStepViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func yesNoModEnabled(bool:Bool)
    
    func blackBorderColor()
    
    func hideLoadingIndicator()
}
