//
//  ViewControllerExtension.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/19/24.
//

import UIKit

extension UIViewController{
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.view.tintColor = .systemOrange
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }
}
