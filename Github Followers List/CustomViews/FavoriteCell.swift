//
//  FavoriteCell.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/23/24.
//

import UIKit

class FavoriteCell: UITableViewCell {

    static let reuseIdentifier = "FavoriteCell"
    let avatarImageView = FollowerProfileImage(frame: .zero)
    let usernameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(favorite: Followers){
        usernameLabel.text = favorite.login
        avatarImageView.downloadImage(from: favorite.avatarUrl)
    }
    
    private func configure(){
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.textAlignment = .left
        usernameLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        usernameLabel.textColor = .label // ili .black za tamne boje
        usernameLabel.numberOfLines = 1
        accessoryType = .disclosureIndicator
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            
            usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: padding*2),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
        ])
    }
    
}
