//
//  SearchViewController.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/9/24.
//

import UIKit

class SearchViewController: UIViewController {

    private let logoImageView = UIImageView()
    private let textField = CustomTextField()
    private let searchButton = CustomButton(title: "Search for username", backgroundColor: .systemOrange, buttonImage: "magnifyingglass.circle.fill")
    var textFieldIsNotEmpty: Bool{ return !textField.text!.isEmpty}
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLogoImageView()
        configureTextField()
        configureSearchButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func configureLogoImageView(){
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(systemName: "person.and.background.dotted")
        let screenWidth = UIScreen.main.bounds.width
        let imageSize = screenWidth * 0.5
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: imageSize),
            logoImageView.widthAnchor.constraint(equalToConstant: imageSize)
        ])
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.tintColor = .systemOrange
    }
    
    func configureTextField(){
        textField.delegate = self
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            textField.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    func configureSearchButton(){
        view.addSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -128),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 72),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -72),
            searchButton.heightAnchor.constraint(equalToConstant: 48)
            ])
        searchButton.addTarget(self, action: #selector(pushToSearchResults), for: .touchUpInside)
    }
    
    @objc func pushToSearchResults(){
        guard textFieldIsNotEmpty else { showAlert(title: "Warning!", message: "Text Field is empty!") ; return }
        let followersVC = FollowersListViewController()
        followersVC.title = textField.text
        navigationController?.pushViewController(followersVC, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.view.tintColor = .systemOrange
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }
    
    //TODO: 2:59:46
}

extension SearchViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
