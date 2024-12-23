//
//  FavoritesViewController.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/9/24.
//

import UIKit

class FavoritesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: 9:48:43
        PersistenceManager.retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                print(favorites)
            case .failure(let error):
                print(error)
            }
        }
    }

}
