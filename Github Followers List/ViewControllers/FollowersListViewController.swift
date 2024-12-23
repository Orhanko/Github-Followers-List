//
//  FollowersListViewController.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/10/24.
//

import UIKit

protocol FollowersListViewControllerDelegate: AnyObject{
    func didSelectFollowers(for username: String)
    func didSelectFollowing(for username: String)
}

class FollowersListViewController: UIViewController {
    
    enum Section{
        case main
    }
    
    var followers: [Followers] = []
    var following: [Followers] = []
    var filteredFollowers: [Followers] = []
    var username: String = ""
    var page = 1
    var collectionView: UICollectionView!
    var getFollowersFinished = false
    var getFollowingFinished = false
    var hasMoreFollowers = true
    var hasMoreFollowing = true
    var followingPage = 1
    var isSearching = false
    var isShowingFollowers = true // Praćenje trenutnog segmenta
    var loaderView: UIView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Followers>!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        configureSegmentedControl()
        configureCollectionView()
        getFollowers(username: username, page: page)
        configureVC()
        configureDataSource()
        
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureSegmentedControl() {
        let segmentedControl = UISegmentedControl(items: ["Followers", "Following"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentTintColor = .systemOrange
        segmentedControl.backgroundColor = .secondarySystemBackground
        
        navigationItem.titleView = segmentedControl
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        isShowingFollowers = sender.selectedSegmentIndex == 0
        removeEmptyFollowerListView() // Ukloni eventualnu poruku

        if isShowingFollowers {
            if followers.isEmpty {
                if !getFollowersFinished { // Proveri da li je fetch već pokušan
                    getFollowersFinished = true
                    getFollowers(username: username, page: 1)
                } else {
                    DispatchQueue.main.async {
                        self.showEmptyFollowerListView(for: .followers)
                    }
                }
            } else {
                DispatchQueue.main.async{
                    self.navigationItem.searchController?.searchBar.isHidden = false
                }
                updateData(on: followers) // Prikaži followers niz
            }
        } else {
            if following.isEmpty {
                if !getFollowingFinished { // Proveri da li je fetch već pokušan
                    getFollowingFinished = true
                    getFollowing(username: username, page: 1)
                } else {
                    DispatchQueue.main.async {
                        self.showEmptyFollowerListView(for: .following)
                    }
                }
            } else {
                DispatchQueue.main.async{
                    self.navigationItem.searchController?.searchBar.isHidden = false
                }
                updateData(on: following) // Prikaži following niz
            }
        }
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createThreeColumnFlowLayout())
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseIdentifier )
        collectionView.alwaysBounceVertical = true
        collectionView.contentInsetAdjustmentBehavior = .automatic
    }
    
    func createThreeColumnFlowLayout() -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 16
        let minimumItemSpacing: CGFloat = 10
        let availbaleWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availbaleWidth / 3
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
    
    func getFollowers(username: String, page: Int) {
        showLoadingView()
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            self?.dismissLoadingView()
            switch result{
            case .success(let followers):
                DispatchQueue.main.async {
                    self?.configureNavigationBarButtons()
                }
                if followers.count < 15 {self?.hasMoreFollowers = false}
                self?.followers.append(contentsOf: followers)
                if self?.followers.isEmpty == true {
                    DispatchQueue.main.async { self?.showEmptyFollowerListView(for: .followers) }
                    return
                }
                self?.updateData(on: self!.followers)
                DispatchQueue.main.async {
                    self?.navigationItem.searchController?.searchBar.isHidden = false // Prikaz UISearchController
                    
                }
            
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.navigationItem.titleView?.isHidden = true
                    self?.handleUserNotFoundError(error)
                }
            }
            
        }
    }
    
    func getFollowing(username: String, page: Int) {
        showLoadingView()
        NetworkManager.shared.getFollowing(for: username, page: page) { [weak self] result in
            self?.dismissLoadingView()
            switch result {
            case .success(let following):
                DispatchQueue.main.async {
                    self?.configureNavigationBarButtons()
                }
                if following.isEmpty {
                    DispatchQueue.main.async {
                        self?.showEmptyFollowerListView(for: .following)
                    }
                } else {
                    if following.count < 15 { self?.hasMoreFollowing = false }
                    self?.following.append(contentsOf: following)
                    if self?.isShowingFollowers == false {
                        self?.updateData(on: self!.following)
                    }
                    DispatchQueue.main.async {
                        self?.navigationItem.searchController?.searchBar.isHidden = false // Prikaz UISearchController
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.handleUserNotFoundError(error)
                }
            }
        }
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Followers>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseIdentifier, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData(on followers: [Followers]){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Followers>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { self.dataSource?.apply(snapshot, animatingDifferences: true) }
        
    }
    
    func showLoadingView(){
        loaderView = UIView(frame: view.bounds)
        view.addSubview(loaderView)
        loaderView.backgroundColor = .systemBackground
        loaderView.alpha = 0
        UIView.animate(withDuration: 0.25){ self.loaderView.alpha = 0.8 }
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        loaderView.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicatorView.centerYAnchor.constraint(equalTo: loaderView.centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: loaderView.centerXAnchor)
        ])
        activityIndicatorView.startAnimating()
    }
    
    func dismissLoadingView(){
        DispatchQueue.main.async {
            self.loaderView.removeFromSuperview()
            self.loaderView = nil
        }
    }
    
    func removeEmptyFollowerListView() {
        DispatchQueue.main.async {
            for subview in self.view.subviews {
                if subview is CustomInfoView {
                    subview.removeFromSuperview()
                }
            }
        }
        
    }
    
    func showEmptyFollowerListView(for message: customEmptyInfoViewType){
        let emptyView = CustomInfoView(imageName: "person.2.slash.fill", message: message, emoji: "👀")
        emptyView.frame = view.bounds
        view.addSubview(emptyView)
        navigationItem.searchController?.searchBar.isHidden = true
        
    }
    
    func handleUserNotFoundError(_ error: CustomErrorForGetFollowers){
        switch error {
        case .userNotFound:
            let notFoundView = CustomInfoView(imageName: "person.fill.xmark", message: .notFound, emoji: "😔")
            notFoundView.frame = view.bounds
            view.addSubview(notFoundView)
        default: return
        }
        
    }
    
    @objc func showUserInfoViewController(){
        let destVC = UserInfoViewController()
        destVC.username = self.title
        destVC.delegate = self
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
    
    func configureNavigationBarButtons() {
        
        let personCircleButton = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(showUserInfoViewController)
        )
        navigationItem.rightBarButtonItem = personCircleButton
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for specific user..."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.searchBar.isHidden = true
    }
}

extension FollowersListViewController: UICollectionViewDelegate{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsety = scrollView.contentOffset.y
        let height = scrollView.frame.height // height ekrana u tom trenutku
        let contentHeight = scrollView.contentSize.height // citav scrollView sa sadrzajem
        
        if offsety > contentHeight - height {
            if isShowingFollowers {
                guard hasMoreFollowers else { return }
                page += 1
                getFollowers(username: username, page: page)
            } else {
                guard hasMoreFollowing else { return }
                followingPage += 1
                getFollowing(username: username, page: followingPage)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray: [Followers]
        if isSearching {
                activeArray = filteredFollowers
            } else {
                activeArray = isShowingFollowers ? followers : following
            }
        let follower = activeArray[indexPath.item]
        let destVC = UserInfoViewController()
        destVC.username = follower.login
        destVC.delegate = self
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
        
    }
}

extension FollowersListViewController: UISearchResultsUpdating, UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else{ return }
        isSearching = true
        if isShowingFollowers {
            filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
            updateData(on: filteredFollowers)
        } else {
            filteredFollowers = following.filter { $0.login.lowercased().contains(filter.lowercased()) }
            updateData(on: filteredFollowers)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        if isShowingFollowers {
            updateData(on: followers)
        } else {
            updateData(on: following)
        }
    }
}

extension FollowersListViewController: FollowersListViewControllerDelegate{
    func didSelectFollowing(for username: String) {
        self.username = username
        title = username
        followers.removeAll()
        following.removeAll()
        filteredFollowers.removeAll()
        page = 1
        followingPage = 1
        hasMoreFollowers = true
        hasMoreFollowing = true
        getFollowingFinished = false
        getFollowersFinished = false
        if let segmentedControl = navigationItem.titleView as? UISegmentedControl {
                segmentedControl.selectedSegmentIndex = 1
            isShowingFollowers = false
            }
        collectionView.reloadData()
        scrollCollectionViewToTop() // Pomjeri sadržaj na vrh
        removeEmptyFollowerListView()
        getFollowing(username: username, page: followingPage)
    }
    
    
    func scrollCollectionViewToTop() {
        let topRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        collectionView.scrollRectToVisible(topRect, animated: true)
    }
    
    func didSelectFollowers(for username: String) {
        self.username = username
        title = username
        followers.removeAll()
        following.removeAll()
        filteredFollowers.removeAll()
        page = 1
        followingPage = 1
        hasMoreFollowers = true
        hasMoreFollowing = true
        getFollowingFinished = false
        getFollowersFinished = false
                if let segmentedControl = navigationItem.titleView as? UISegmentedControl {
                segmentedControl.selectedSegmentIndex = 0
            isShowingFollowers = true
            }
        collectionView.reloadData()
        scrollCollectionViewToTop() // Pomjeri sadržaj na vrh
        removeEmptyFollowerListView()
        getFollowers(username: username, page: page)
    }
    
    
}
