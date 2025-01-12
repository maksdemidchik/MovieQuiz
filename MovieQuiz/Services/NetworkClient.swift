//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Maxim on 20.12.2024.
//

import Foundation

protocol NetworkRouting{
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}


struct NetworkClient: NetworkRouting {
    private enum networkError:Error{
        case codeError
    }
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void){
        let request=URLRequest(url: url)
        let task=URLSession.shared.dataTask(with: request){data,response,error in
            if let error=error{
                handler(.failure(error))
            }
            if let response=response as? HTTPURLResponse,response.statusCode<200 || response.statusCode>=300 {
                 handler(.failure(networkError.codeError))
                return
            }
            guard let data=data else{
                return
            }
            handler(.success(data))
        }
        task.resume()
    }
}
