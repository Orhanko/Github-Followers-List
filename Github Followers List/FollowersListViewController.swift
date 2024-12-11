//
//  FollowersListViewController.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/10/24.
//

import UIKit

class FollowersListViewController: UIViewController {

    let networkManager = NetworkManager()
    var username: String = ""
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        networkManager.getFollowers(for: username) { result in
            switch result{
            case .success(let followers):
                for follower in followers {
                    print("Login: \(follower.login), Avatar URL: \(follower.avatarUrl)")
                    print("----------------------------------")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
            
        }
    }
}
