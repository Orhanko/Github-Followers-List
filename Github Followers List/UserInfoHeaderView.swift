//
//  UserInfoHeaderView.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/13/24.
//

import UIKit

class UserInfoHeaderView: UIView {

    var user: User?
    let imageView = FollowerProfileImage(frame: .zero)
    let username = UILabel()
    let firstNameLastName = UILabel()
    let locationImageView = UIImageView()
    let locationLabel = UILabel()
    let bio = UILabel()
    override init(frame: CGRect) {
        self.user = nil
        super.init(frame: frame)
        addSubviews()
        configureConstraints()
        configureData()
    }
    
    init(user: User) {
        super.init(frame: .zero)
        self.user = user
        addSubviews()
        configureConstraints()
        configureData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureData() {
        /*TODO: IZMIJENITI:*/ imageView.downloadImage(from: user!.avatarUrl)
        username.text = user?.login //?? "Orhanko" //TODO: OVO OBAVEZNO IZBRISATI
        firstNameLastName.text =  user?.name ??  "Full name ❌" //TODO: OVO OBAVEZNO PROMIJENITI NA: "Full name not available"
        //firstNameLastName.backgroundColor = .systemBlue
        locationImageView.image = UIImage(systemName: "mappin.and.ellipse")
        locationLabel.text = user?.location ?? "Location ❌"
        locationImageView.tintColor = locationLabel.text == user?.location ? .systemBlue : .secondaryLabel
        bio.text = user?.bio ?? "Biography not available"
        locationLabel.lineBreakMode = .byWordWrapping
        locationLabel.numberOfLines = 0
        bio.lineBreakMode = .byWordWrapping
        bio.numberOfLines = 0
        bio.textColor = .secondaryLabel
        username.font = .preferredFont(forTextStyle: .extraLargeTitle)
        firstNameLastName.font = .boldSystemFont(ofSize: 22)
        firstNameLastName.textColor = .secondaryLabel
        locationLabel.textColor = .secondaryLabel
    }
    
    func addSubviews() {
        addSubview(imageView)
        addSubview(username)
        addSubview(firstNameLastName)
        addSubview(locationImageView)
        addSubview(locationLabel)
        addSubview(bio)
    }
    
    func configureConstraints() {
        let padding: CGFloat = 20
        
        let textFromImagePadding: CGFloat = 10
        
        //locationLabel.backgroundColor = .systemOrange
        //locationImageView.backgroundColor = .systemRed
        
        //imageView.translatesAutoresizingMaskIntoConstraints = false
        username.translatesAutoresizingMaskIntoConstraints = false
        firstNameLastName.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationImageView.translatesAutoresizingMaskIntoConstraints = false
        bio.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            imageView.heightAnchor.constraint(equalToConstant: 120),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            
            username.topAnchor.constraint(equalTo: imageView.topAnchor),
            username.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: textFromImagePadding),
            username.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
//            username.heightAnchor.constraint(equalToConstant: 20),
            
            firstNameLastName.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: 5),
            firstNameLastName.leadingAnchor.constraint(equalTo: username.leadingAnchor),
            firstNameLastName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            //firstNameLastName.heightAnchor.constraint(equalToConstant: 20),
            
            locationImageView.leadingAnchor.constraint(equalTo: firstNameLastName.leadingAnchor),
            locationImageView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            locationImageView.heightAnchor.constraint(equalToConstant: 30),
            locationImageView.widthAnchor.constraint(equalToConstant: 30),
            
            locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 5),
            locationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
//            locationLabel.heightAnchor.constraint(equalToConstant: 20),
            
            bio.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            bio.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding),
            bio.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            bio.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
    }
    
}
