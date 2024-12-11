//
//  NetworkManager.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/11/24.
//

import Foundation

enum CustomError: String, Error{
    case invalidURL = "Invalid URL"
    case errorData = "Check your internet connection"
    case invalidResponse = "Invalid response"
    case dataMissing = "No data"
}

class NetworkManager {
    let baseURL = "https://api.github.com/users/"
    
    func getFollowers(for username: String, completion: @escaping (Result<[Followers], CustomError>) -> Void ){
        let endpoint = baseURL + username + "/followers"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(.failure(.errorData))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    completion(.failure(.invalidResponse))
                    return
                }
            }
            
            guard let data else {
                completion(.failure(.dataMissing))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Followers].self, from: data)
                completion(.success(followers))
            } catch {
                completion(.failure(.dataMissing))
            }
        }
        task.resume()
    }
}

