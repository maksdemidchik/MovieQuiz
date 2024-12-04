//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Maxim on 29.11.2024.
//

import Foundation
import UIKit
final class AlertPresenter{
    private weak var viewController:UIViewController?
    func setViewController(_ viewController: UIViewController){
       self.viewController = viewController
    }
    func showAlert(quiz result: AlertModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            result.completion?()
        }
        
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    }
}

