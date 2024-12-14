//
//  UserInfoViewController.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/12/24.
//

import UIKit

class UserInfoViewController: UIViewController {
    var username: String!
    let headerView = UserInfoHeaderView()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Kreirajte izgled navigation bar-a sa default pozadinom
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()

        // Primijenite izgled na navigation bar samo za ovaj ViewController
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        title = username
        NetworkManager.shared.getUserInfo(for: username) { result in
            switch result {
            case .success(let user):
                print("\(user.login), \(user.avatarUrl), \(user.name ?? "Name default"), \(user.location ?? "lokacijadefault"), \(user.bio ?? "bio default"), \(user.publicRepos), \(user.publicGists), \(user.htmlUrl), \(user.followers), \(user.following), \(user.createdAt)")
            case .failure(let error):
                return print(error)
            }
        }
        
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    
    func layoutUI() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
