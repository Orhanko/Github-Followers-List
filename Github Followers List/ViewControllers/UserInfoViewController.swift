//
//  UserInfoViewController.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/12/24.
//

import UIKit
import SafariServices

protocol UserInfoViewControllerDelegate: AnyObject{
    func didTapGithubProfile(for user: User)
    func didTapGetFollowers(for user: User)
    func didTapGetFollowing(for user: User)
}

class UserInfoViewController: UIViewController {
    var username: String!
    var follower: Followers?
    let headerView = UserInfoHeaderView()
    let dateLabel = UILabel()
    var starButton = UIBarButtonItem()
    weak var delegate: FollowersListViewControllerDelegate!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        updateFavoriteButton()
        title = username
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            switch result {
            case .success(let user):
                self?.follower = Followers(login: user.login, avatarUrl: user.avatarUrl)
                print("Follower login: \(self?.follower?.login ?? "Karina 1")")
                print("Follower avatar URL: \(self?.follower?.avatarUrl ?? "Karina 2")")
                DispatchQueue.main.async {
                    self?.layoutUI(with: user)
                    self?.headerView.configureHeaderView(for: user)
                    self?.dateLabel.text = "Github Profile created in \(self?.formatISODateString(user.createdAt) ?? "")"
                    self?.updateFavoriteButton()
                }
            case .failure(let error):
                return print(error)
            }
        }
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    @objc func starButtonTapped(){
        guard let follower else {
            showAlert(title: "Error", message: "pizda li ti materna")
            return }
        PersistenceManager.updateWith(favorite: follower, actionType: .add) { [weak self] error in
            guard let error = error else{
                self?.updateFavoriteButton()
                self?.showAlert(title: "Success!", message: "User successfully added to favorites!")
                return
            }
            self?.showAlert(title: "Error", message: error.rawValue)
        }
    }
    
    func updateFavoriteButton() {
        guard let follower = follower else { return }
        
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let favorites):
                let isFavorite = favorites.contains(where: { $0.login == follower.login })
                
                DispatchQueue.main.async {
                    let buttonImage = isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
                    self.starButton.image = buttonImage
                }
                
            case .failure:
                DispatchQueue.main.async {
                    self.starButton.image = UIImage(systemName: "star")
                }
            }
        }
    }
    
    
    func layoutUI(with user: User) {
        let itemInfoOne = RepoItemInfoView(user: user)
        let itemInfoTwo = FollowersInfoView(user: user)
        itemInfoOne.configureItems()
        itemInfoTwo.configureItems()
        itemInfoOne.delegate = self
        itemInfoTwo.delegate = self
        headerView.translatesAutoresizingMaskIntoConstraints = false
        itemInfoOne.translatesAutoresizingMaskIntoConstraints = false
        itemInfoTwo.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textAlignment = .center
        dateLabel.textColor = .secondaryLabel
        view.addSubview(headerView)
        view.addSubview(itemInfoOne)
        view.addSubview(itemInfoTwo)
        view.addSubview(dateLabel)
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
            
            dateLabel.topAnchor.constraint(equalTo: itemInfoTwo.bottomAnchor, constant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
        
    }
    
    func configureNavigationBar() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        starButton = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(starButtonTapped))
        navigationItem.leftBarButtonItem = starButton
    }
    
    
    
    func formatISODateString(_ dateString: String) -> String? {
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [.withInternetDateTime, .withColonSeparatorInTime] // Osigurava kompatibilnost
        
        guard let date = inputFormatter.date(from: dateString) else {
            return nil
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMMM yyyy"
        outputFormatter.locale = Locale(identifier: "en_US")
    
        return outputFormatter.string(from: date)
    }
}

extension UserInfoViewController: UserInfoViewControllerDelegate {
    func didTapGetFollowing(for user: User) {
        print("Get Following isto radi")
        delegate.didSelectFollowing(for: user.login)
        dismissVC()
    }
    
    func didTapGithubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            print("Nesto ne valja")
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemOrange
        present(safariVC, animated: true)
    }

    func didTapGetFollowers(for user: User) {
        print("Get followers isto radi")
        delegate.didSelectFollowers(for: user.login)
        dismissVC()
    }
    
}
