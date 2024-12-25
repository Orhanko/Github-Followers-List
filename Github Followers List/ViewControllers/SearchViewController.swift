//
//  SearchViewController.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/9/24.
//

import UIKit
//TODO: 5:44:30
class SearchViewController: UIViewController {

    private let logoImageView = UIImageView()
    private let textField = CustomTextField()
    private let searchButton = CustomButton(title: "Search for username", backgroundColor: .systemOrange, buttonImage: "magnifyingglass.circle.fill")
    var textFieldIsNotEmpty: Bool{ return !textField.text!.isEmpty }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLogoImageView()
        configureTextField()
        configureSearchButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let keyboardHeight = keyboardFrame.height
        view.frame.origin.y = -keyboardHeight / 6
    }

    @objc func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        textField.text = ""
    }
    
    func configureLogoImageView(){
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "github-mark")?.withRenderingMode(.alwaysTemplate)
        let screenWidth = UIScreen.main.bounds.width
        let imageSize = screenWidth * 0.5
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
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
            textField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 70),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            textField.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    func configureSearchButton(){
        view.addSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 80),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 72),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -72),
            searchButton.heightAnchor.constraint(equalToConstant: 48)
            ])
        searchButton.addTarget(self, action: #selector(pushToSearchResults), for: .touchUpInside)
    }
    
    @objc func pushToSearchResults(){
        guard textFieldIsNotEmpty else { showAlert(title: "Warning!", message: "Text Field is empty!") ; return }
        textField.resignFirstResponder()
        let followersVC = FollowersListViewController(username: textField.text!)
        navigationController?.pushViewController(followersVC, animated: true)
    }
    
}

extension SearchViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
