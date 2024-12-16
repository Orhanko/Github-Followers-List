//
//  CustomInfoView.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/12/24.
//

import UIKit

class CustomInfoView: UIView {

    private let image = UIImageView()
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(imageName: "", message: "", emoji: "")
    }
    
    init(imageName: String, message: String, emoji: String) {
        super.init(frame: .zero)
        configure(imageName: imageName, message: message, emoji: emoji)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(imageName: String, message: String, emoji: String) {
        let combinedLabel = UILabel()
        addSubview(combinedLabel)
        addSubview(image)

        // Postavljanje slike
        image.image = UIImage(systemName: imageName)
        image.semanticContentAttribute = .forceRightToLeft
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.tintColor = UIColor.systemOrange.withAlphaComponent(0.4)

        // Kreiranje atributisanog stringa za tekst i emoji
        let attributedString = NSMutableAttributedString(string: message, attributes: [
            .font: UIFont.systemFont(ofSize: 30, weight: .bold),
            .foregroundColor: UIColor.secondaryLabel
        ])
        let emojiAttributedString = NSAttributedString(string: emoji, attributes: [
            .font: UIFont.systemFont(ofSize: 30)
        ])
        attributedString.append(emojiAttributedString)

        // Postavljanje teksta
        combinedLabel.attributedText = attributedString
        combinedLabel.numberOfLines = 0
        combinedLabel.textAlignment = .center
        combinedLabel.translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = .systemBackground

        // Auto Layout
        let screenWidth = UIScreen.main.bounds.width
        let imageSize = screenWidth * 1

        NSLayoutConstraint.activate([
            combinedLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -200),
            combinedLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            combinedLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40)
        ])
        
        // Uslov za različite dimenzije u zavisnosti od slike
        if imageName == "person.fill.xmark" {
            NSLayoutConstraint.activate([
                image.widthAnchor.constraint(equalToConstant: imageSize),
                image.heightAnchor.constraint(equalToConstant: imageSize),
                image.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 25),
                image.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 65)
            ])
        } else if imageName == "person.2.slash.fill" {
            NSLayoutConstraint.activate([
                
                image.widthAnchor.constraint(equalToConstant: imageSize),
                image.heightAnchor.constraint(equalToConstant: imageSize),
                image.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 25),
                image.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 90)
            ])
        }
    }
}
