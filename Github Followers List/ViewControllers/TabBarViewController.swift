//
//  TabBarViewController.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/25/24.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemOrange
        viewControllers = [configureSearchVC(), configureFavoritesVC()]
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground() // Moderni zamagljeni izgled
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
     
    }
    func configureSearchVC() -> UINavigationController {
        let searchVC = SearchViewController()
        searchVC.title = "Search"
        searchVC.view.backgroundColor = .systemBackground
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        let navigationController = UINavigationController(rootViewController: searchVC)
        return navigationController
    }
    
    func configureFavoritesVC() -> UINavigationController {
        let favoritesVC = FavoritesViewController()
        favoritesVC.title = "Favorites"
        favoritesVC.view.backgroundColor = .systemBackground
        favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        let navigationController = UINavigationController(rootViewController: favoritesVC)
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
}
