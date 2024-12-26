//
//  FollowerCell.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/11/24.
//

import UIKit
extension Notification.Name {
    static let didFavoriteUser = Notification.Name("didFavoriteUser")
}

class FollowerCell: UICollectionViewCell {
    static let reuseIdentifier = "FollowerCell"
    private var currentFollower: Followers? // Svojstvo za čuvanje korisnika
    
    
    let avatarImageView = FollowerProfileImage(frame: .zero)
    let usernameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        addContextMenuInteraction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(follower: Followers) {
        currentFollower = follower
        usernameLabel.text = follower.login
        avatarImageView.downloadImage(from: follower.avatarUrl)
    }
    
    func configure() {
        usernameLabel.textAlignment = .center
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func favoriteText (for follower: Followers) -> String? {
        var isFavorite = false
        
        PersistenceManager.retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                isFavorite = favorites.contains(where: { $0.login == follower.login })
            case .failure:
                isFavorite = false
            }
        }
        
        return isFavorite ? "Already added to favorites!" : "Add to favorites"
    }
    
    func favoriteIcon(for follower: Followers) -> UIImage {
        var isFavorite = false
        
        PersistenceManager.retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                isFavorite = favorites.contains(where: { $0.login == follower.login })
            case .failure:
                isFavorite = false
            }
        }
        
        return isFavorite ? UIImage(systemName: "star.fill")! : UIImage(systemName: "star")!
    }
}

extension FollowerCell: UIContextMenuInteractionDelegate {
    private func addContextMenuInteraction() {
        let interaction = UIContextMenuInteraction(delegate: self)
        addInteraction(interaction)
    }
        
        
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard let follower = currentFollower else { return nil }
        
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self]  _ in
            let favoriteAction = UIAction(title: self?.favoriteText(for: follower) ?? follower.login, image: self?.favoriteIcon(for: follower)) { _ in
                NotificationCenter.default.post(name: .didFavoriteUser, object: follower)
            }
            return UIMenu(title: "", children: [favoriteAction])
        }
    }
}
