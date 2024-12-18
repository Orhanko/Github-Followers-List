//
//  FollowersInfoView.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/18/24.
//

import UIKit

class FollowersInfoView: UIView {

    
    let leftButton = CustomButton()
    let rightButton = CustomButton()
    let itemInfoViewOne = ItemInfoCell()
    let itemInfoViewTwo = ItemInfoCell()
    let stackView = UIStackView()
    weak var delegate: UserInfoViewControllerDelegate!
    var user: User!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        layoutUI()
        configureStackView()
        configureButtonAction()
    }
    
    init(user: User){
        super.init(frame: .zero)
        self.user = user
        configure()
        layoutUI()
        configureStackView()
        configureButtonAction()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        layer.cornerRadius = 18
        backgroundColor = .secondarySystemBackground
    }
    
    func configureItems(){
        itemInfoViewOne.set(itemInfoType: .followers, with: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, with: user.following)
        leftButton.configureItemInfoButton(title: "Get Followers", backgroundColor: .systemOrange)
        rightButton.configureItemInfoButton(title: "Get Following", backgroundColor: .systemBlue)
    }
    
    func configureStackView(){
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(itemInfoViewOne)
        stackView.addArrangedSubview(itemInfoViewTwo)
    }
    
    func configureButtonAction(){
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
    }
    
    @objc func leftButtonTapped(){
        delegate.didTapGetFollowers(for: user)
    }
    
    @objc func rightButtonTapped(){
        delegate.didTapGetFollowing(for: user)
    }
    
    func layoutUI(){
        let padding: CGFloat = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        addSubview(leftButton)
        addSubview(rightButton)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding*1.5),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding*1.5),
            
            leftButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: padding),
            leftButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            leftButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -padding),
            leftButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            leftButton.heightAnchor.constraint(equalToConstant: 48),
            
            rightButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: padding),
            rightButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: padding),
            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            rightButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            rightButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
    
}
