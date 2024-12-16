//
//  ItemInfoViewController.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/16/24.
//

import UIKit

class ItemInfoViewController: UIView {

    
    let button = UIButton()
    let itemInfoViewOne = ItemInfoView()
    let itemInfoViewTwo = ItemInfoView()
    let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        layoutUI()
        configureStackView()
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
    
    func layoutUI(){
        let padding: CGFloat = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        addSubview(button)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            button.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: padding),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
    }
    
}
