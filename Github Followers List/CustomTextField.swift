//
//  CustomTextField.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/9/24.
//

import UIKit

class CustomTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        dismissKeyboard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
        placeholder = "Enter Github Username..."
        textColor = .label
        tintColor = .systemOrange
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .headline)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        backgroundColor = .quaternarySystemFill
        autocorrectionType = .no
        returnKeyType = .default
    }
    
    func dismissKeyboard() {
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(closeKeyboard))
        doneButton.tintColor = .systemOrange
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexSpace, doneButton]
        self.inputAccessoryView = toolbar
        
        for constraint in toolbar.constraints {
            print(constraint)
        }
    }
    
    @objc func closeKeyboard() {
        self.resignFirstResponder()
    }
    
    
    
}
