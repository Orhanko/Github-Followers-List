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
        imageView.image = UIImage(systemName: "person.circle")
        username.text = "Username proba"
        firstNameLastName.text =  "FirstName LastName"
        locationImageView.image = UIImage(systemName: "mappin.and.ellipse")
        locationLabel.text = "Location"
        bio.text = "Ovo je tekst koji ce sluziti za deskripciju korisnika, koju je sam napravio na github profilu. Pisem ovaj tekst iz razloga da testiram kako ce ponasati u slucaju ako je potrebno dva ili redova i da li ce se automatski izracunavati visina ovog container view-a."
        bio.lineBreakMode = .byWordWrapping
        bio.numberOfLines = 0
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
            
            username.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 5),
            username.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: textFromImagePadding),
            username.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
//            username.heightAnchor.constraint(equalToConstant: 20),
            
            firstNameLastName.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            firstNameLastName.leadingAnchor.constraint(equalTo: username.leadingAnchor),
            firstNameLastName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            firstNameLastName.heightAnchor.constraint(equalToConstant: 20),
            
            locationImageView.leadingAnchor.constraint(equalTo: firstNameLastName.leadingAnchor),
            locationImageView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -5),
            locationImageView.heightAnchor.constraint(equalToConstant: 25),
            locationImageView.widthAnchor.constraint(equalToConstant: 25),
            
            locationLabel.bottomAnchor.constraint(equalTo: locationImageView.bottomAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 5),
            locationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
//            locationLabel.heightAnchor.constraint(equalToConstant: 20),
            
            bio.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            bio.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: textFromImagePadding),
            bio.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            bio.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
    }
    
}
