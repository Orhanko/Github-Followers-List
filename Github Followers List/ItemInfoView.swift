//
//  ItemInfoView.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/16/24.
//

import UIKit

enum ItemInfoViewType {
    case followers
    case following
    case repos
    case gists
}

class ItemInfoView: UIView {
    
    let symbolImageVIew = UIImageView()
    let title = UILabel()
    let countLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(symbolImageVIew)
        addSubview(title)
        addSubview(countLabel)
        
        symbolImageVIew.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        symbolImageVIew.contentMode = .scaleAspectFill
        symbolImageVIew.tintColor = .label
        
        NSLayoutConstraint.activate([
            symbolImageVIew.topAnchor.constraint(equalTo: topAnchor),
            symbolImageVIew.leadingAnchor.constraint(equalTo: leadingAnchor),
            symbolImageVIew.widthAnchor.constraint(equalToConstant: 20),
            symbolImageVIew.heightAnchor.constraint(equalToConstant: 20),
            
            title.centerYAnchor.constraint(equalTo: symbolImageVIew.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: symbolImageVIew.trailingAnchor, constant: 12),
            title.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            countLabel.topAnchor.constraint(equalTo: symbolImageVIew.bottomAnchor, constant: 4),
            countLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            countLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func set(itemInfoType: ItemInfoViewType, with count: Int){
        switch itemInfoType {
        case .followers:
            symbolImageVIew.image = UIImage(systemName: "person.2")
            title.text = "Followers"
        case .following:
            symbolImageVIew.image = UIImage(systemName: "heart")
            title.text = "Following"
        case .repos:
            symbolImageVIew.image = UIImage(systemName: "folder")
            title.text = "Public Repos"
        case .gists:
            symbolImageVIew.image = UIImage(systemName: "text.alignleft")
            title.text = "Public Gists"
        }
        countLabel.text = String(count)
    }
    
}
