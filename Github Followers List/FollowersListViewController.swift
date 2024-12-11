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
        networkManager.getFollowers(for: username) { followers, errorMessage in
            print(self.username)
            if let errorMessage {
                print(errorMessage)
                return
            }
            for follower in followers! {
                    print("Login: \(follower.login), Avatar URL: \(follower.avatarUrl)")
                }
        }
    }
}
