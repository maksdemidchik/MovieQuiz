//
//  TestPresenter.swift
//  TestPresenter
//
//  Created by Maxim on 09.01.2025.
//


import UIKit
import XCTest
@testable import MovieQuiz


final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func showLoadingIndicator(){
        
    }
    
    func showNetworkError(message: String){
        
    }
    
    func show(quiz step: QuizStepViewModel){
        
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool){
        
    }
    
    func yesNoModEnabled(bool:Bool){
        
    }
    
    func blackBorderColor(){
        
    }
    
    func hideLoadingIndicator(){
        
    }
    
    
}
final class TestPresenter: XCTestCase {
    
    func testPresenterConvertModel() throws {
            let viewControllerMock = MovieQuizViewControllerMock()
            let sut = MovieQuizPresenter(viewController: viewControllerMock)
            
            let emptyData = Data()
            let question = QuizQuestion(image: emptyData, text: "Question Text", corretAnswer: true)
            let viewModel = sut.convert(model: question)
            
            XCTAssertNotNil(viewModel.image)
            XCTAssertEqual(viewModel.question, "Question Text")
            XCTAssertEqual(viewModel.questionNumber, "1/10")
        }
    
}
