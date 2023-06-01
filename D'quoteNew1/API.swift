//
//  API.swift
//  D'quoteNew1
//
//  Created by Dorukhan Demir on 30.03.2023.
//

import Foundation

class API {
    
    static let shared = API()
    
    func fetchRandomQuote(completion: @escaping (Result<Quote, Error>) -> Void) {
        guard let url = URL(string: "https://api.quotable.io/random") else {
            completion(.failure(NSError(domain: "API Error", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(.failure(error ?? NSError(domain: "API Error", code: 0, userInfo: nil)))
                return
            }
            if let decodedResponse = try? JSONDecoder().decode(Quote.self, from: data) {
                completion(.success(decodedResponse))
            } else {
                completion(.failure(NSError(domain: "API Error", code: 0, userInfo: nil)))
            }
        }.resume()
    }
    
    func startTimer(completion: @escaping () -> Void) {
        Timer.scheduledTimer(withTimeInterval: 1 * 60, repeats: true) { _ in
            completion()
        }
    }
}
