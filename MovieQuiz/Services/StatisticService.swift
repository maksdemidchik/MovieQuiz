//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Maxim on 01.12.2024.
//

import Foundation
final class StatisticService: StatisticServiceProtocol {
    private enum Keys: String {
        case correct
        case bestGame
        case gamesCount
        case correctAnswers
        case total
        case date
    }

    private let storage: UserDefaults = .standard
    private var correctAnswers: Int{
        get{
            storage.integer(forKey: Keys.correctAnswers.rawValue)
        }
        set{
            storage.set(newValue, forKey:  Keys.correctAnswers.rawValue)
        }
    }
    var gamesCount: Int{
        get{
            storage.integer(forKey:  Keys.gamesCount.rawValue)
        }
        set{
            storage.set(newValue, forKey:  Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult{
        get{
            let correct = storage.integer(forKey:Keys.correct.rawValue)
            let total = storage.integer(forKey: Keys.total.rawValue)
            let date = storage.object(forKey: Keys.date.rawValue) as? Date ?? Date()
            return GameResult(correct: correct, total: total, date: date)
        }
        set{
            storage.set(newValue.correct, forKey:Keys.correct.rawValue)
            storage.set(newValue.total,forKey:Keys.total.rawValue)
            storage.set(newValue.date, forKey:Keys.date.rawValue)
        }
        
    }
    var totalAccuracy: Double {
        return (Double(correctAnswers)/(10*Double(gamesCount)))*100
    }
    
    
    func store(correct count: Int, total amount: Int) {
        correctAnswers += count
        gamesCount+=1
        if bestGame.betterThan(GameResult(correct: count, total: amount, date: Date())){
            bestGame = GameResult(correct: count, total: amount, date: Date())
        }
        
    }
}
