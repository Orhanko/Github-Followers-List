//
//  CustomButton.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/9/24.
//

import UIKit

class CustomButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(title: "", buttonImage: "", backgroundColor: .systemBackground)
    }
    
    init (title: String, backgroundColor: UIColor, buttonImage: String) {
        super.init(frame: .zero)
        configure(title: title, buttonImage: buttonImage, backgroundColor: backgroundColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(title: String, buttonImage: String, backgroundColor: UIColor) {
        translatesAutoresizingMaskIntoConstraints = false
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = backgroundColor
        config.title = title
        config.image = UIImage(systemName: buttonImage)
        config.imagePlacement = .trailing
        config.imagePadding = 8
        configuration = config
    }
}
