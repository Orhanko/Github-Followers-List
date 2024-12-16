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
    }
    
    func configureHeaderView(for user: User) {
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
        //username.text = user?.login //?? "Orhanko" //TODO: OVO OBAVEZNO IZBRISATI
        firstNameLastName.text =  user?.name ??  "Full name ❌" //TODO: OVO OBAVEZNO PROMIJENITI NA: "Full name not available"
        locationImageView.image = UIImage(systemName: "mappin.and.ellipse")
        locationLabel.text = user?.location ?? "Location ❌"
        locationImageView.tintColor = locationLabel.text == user?.location ? .systemBlue : .secondaryLabel
        bio.text = user?.bio ?? "Biography not available"
        locationLabel.lineBreakMode = .byWordWrapping
        locationLabel.numberOfLines = 0
        bio.lineBreakMode = .byWordWrapping
        bio.numberOfLines = 0
        bio.textColor = .secondaryLabel
        firstNameLastName.font = .boldSystemFont(ofSize: 26)
        firstNameLastName.textColor = .secondaryLabel
        firstNameLastName.lineBreakMode = .byWordWrapping
        firstNameLastName.numberOfLines = 0
        locationLabel.textColor = .secondaryLabel
    }
    
    func addSubviews() {
        addSubview(imageView)
        addSubview(firstNameLastName)
        addSubview(locationImageView)
        addSubview(locationLabel)
        addSubview(bio)
    }
    
    func configureConstraints() {
        let padding: CGFloat = 20
        let textFromImagePadding: CGFloat = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        firstNameLastName.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationImageView.translatesAutoresizingMaskIntoConstraints = false
        bio.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: textFromImagePadding),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            
            firstNameLastName.topAnchor.constraint(equalTo: imageView.topAnchor, constant: textFromImagePadding),
            firstNameLastName.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: textFromImagePadding),
            firstNameLastName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            locationImageView.leadingAnchor.constraint(equalTo: firstNameLastName.leadingAnchor),
            locationImageView.heightAnchor.constraint(equalToConstant: 30),
            locationImageView.widthAnchor.constraint(equalToConstant: 30),
            
            locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
            locationLabel.topAnchor.constraint(equalTo: firstNameLastName.bottomAnchor, constant: padding),
            locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 5),
            locationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            bio.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            bio.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding),
            bio.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            bio.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
