//
//  PersistenceManager.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/19/24.
//

import Foundation

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    static func retrieveFavorites(completed: @escaping (Result<[Followers], CustomErrorForGetFollowers>) -> Void){
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        
        do{
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Followers].self, from: favoritesData)
            completed(.success(favorites))
        }catch{
            completed(.failure(.unableToFavorite))
        }
    }
    
    static func saveFavorite(favorites: [Followers]) -> CustomErrorForGetFollowers?{
        do{
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch{
            return .unableToFavorite
        }
    }
}
