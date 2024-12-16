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
    let itemInfoOne = RepoItemInfoView()
    let itemInfoTwo = FollowerItemInfoView()
    let proba = FollowerItemInfoView()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        title = username
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self?.layoutUI()
                    self?.headerView.configureHeaderView(for: user)
                    self?.itemInfoOne.configureItems(with: user)
                    self?.itemInfoTwo.configureItems(with: user)
                }
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
        itemInfoOne.translatesAutoresizingMaskIntoConstraints = false
        itemInfoTwo.translatesAutoresizingMaskIntoConstraints = false
        proba.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        view.addSubview(itemInfoOne)
        view.addSubview(itemInfoTwo)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            itemInfoOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            itemInfoOne.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            itemInfoOne.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            itemInfoTwo.topAnchor.constraint(equalTo: itemInfoOne.bottomAnchor, constant: 20),
            itemInfoTwo.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            itemInfoTwo.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
        
    }
}
