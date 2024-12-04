//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Maxim on 01.12.2024.
//

import Foundation
struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    func betterThan(_ number: GameResult)-> Bool{
        correct<number.correct
    }
}
