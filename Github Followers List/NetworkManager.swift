//
//  NetworkManager.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/11/24.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    let cache = NSCache<NSString, UIImage>()
    
    private let baseURL = "https://api.github.com/users/"
    
    func getFollowers(for username: String, completion: @escaping (Result<[Followers], CustomErrorForGetFollowers>) -> Void ){
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

