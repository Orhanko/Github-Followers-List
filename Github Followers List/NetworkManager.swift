//
//  NetworkManager.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/11/24.
//

import Foundation

class NetworkManager {
    let baseURL = "https://api.github.com/users/"
    
    func getFollowers(for username: String, completion: @escaping ([Followers]?, String?) -> Void ){
        let endpoint = baseURL + username + "/followers"
        print("Orhan Pojskic: \(endpoint)")
        
        guard let url = URL(string: endpoint) else {
            completion(nil, "Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(nil, "Ti mi vracas gresku: \(error.localizedDescription)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    completion(nil, "Something went wrong")
                    return
                }
            }
            
            guard let data else {
                completion(nil, "No data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Followers].self, from: data)
                completion(followers, nil)
            } catch {
                completion(nil, error.localizedDescription)
            }
        }
        task.resume()
    }
}

