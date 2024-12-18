//
//  ItemInfoViewController.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/16/24.
//

import UIKit

class ItemInfoView: UIView {

    
    let button = CustomButton()
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
    
    func configureStackView(){
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(itemInfoViewOne)
        stackView.addArrangedSubview(itemInfoViewTwo)
    }
    
    func configureButtonAction(){
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped(){}
    
    func layoutUI(){
        let padding: CGFloat = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        addSubview(button)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding*1.5),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding*1.5),
            
            button.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: padding),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            button.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
}
