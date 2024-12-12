//
//  UserInfoViewController.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/12/24.
//

import UIKit

class UserInfoViewController: UIViewController {
    var username: String!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Kreirajte izgled navigation bar-a sa default pozadinom
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()

        // Primijenite izgled na navigation bar samo za ovaj ViewController
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        title = username
        
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}
