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

class FollowerCell: UICollectionViewCell, UIContextMenuInteractionDelegate {
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
    private func addContextMenuInteraction() {
            let interaction = UIContextMenuInteraction(delegate: self)
            addInteraction(interaction)
        }
        
        // MARK: - UIContextMenuInteractionDelegate
        
        func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
            guard let follower = currentFollower else { return nil }
            
            
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                let favoriteAction = UIAction(title: "Favorite \(self.currentFollower?.login ?? "this user")", image: UIImage(systemName: "star")) { _ in
                    NotificationCenter.default.post(name: .didFavoriteUser, object: follower)
                }
                return UIMenu(title: "", children: [favoriteAction])
            }
        }
}
