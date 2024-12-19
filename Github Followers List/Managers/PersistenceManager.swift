//
//  PersistenceManager.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/19/24.
//

import Foundation

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    static func retrieveFavorites(completed: @escaping (Result<[Followers], Error>) -> Void){}
}
