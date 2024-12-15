//
//  UserInfoViewController.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/12/24.
//

import UIKit

class UserInfoViewController: UIViewController {
    var username: String!
    
    
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
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        title = username
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    let headerView = UserInfoHeaderView(user: user)
                    self?.layoutUI(for: headerView)
                }
            case .failure(let error):
                return print(error)
            }
        }
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    
    func layoutUI(for headerView: UIView) {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
