//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Maxim on 29.11.2024.
//
import UIKit
struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
}
