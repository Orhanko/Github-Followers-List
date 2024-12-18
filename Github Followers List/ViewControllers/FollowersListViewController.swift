//
//  FollowersListViewController.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/10/24.
//

import UIKit

protocol FollowersListViewControllerDelegate: AnyObject{
    func didSelectFollowers(for username: String)
}

class FollowersListViewController: UIViewController {
    
    enum Section{
        case main
    }
    
    var followers: [Followers] = []
    var filteredFollowers: [Followers] = []
    var username: String = ""
    var page = 1
    var collectionView: UICollectionView!
    var hasMoreFollowers = true
    var isSearching = false
    var loaderView: UIView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Followers>!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        configureCollectionView()
        getFollowers(username: username, page: page)
        configureVC()
        configureDataSource()
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
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
                print(followers)
                if followers.count < 15 {self?.hasMoreFollowers = false}
                self?.followers.append(contentsOf: followers)
                if self?.followers.isEmpty == true {
                    DispatchQueue.main.async { self?.showEmptyFollowerListView() }
                    return
                }
                self?.updateData(on: self!.followers)
                DispatchQueue.main.async {
                    self?.navigationItem.searchController?.searchBar.isHidden = false // Prikaz UISearchController
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
    
    func showEmptyFollowerListView(){
        let emptyView = CustomInfoView(imageName: "person.2.slash.fill", message: "Entered user does not have followers yet. ", emoji: "👀")
        emptyView.frame = view.bounds
        view.addSubview(emptyView)
    }
    
    func handleUserNotFoundError(_ error: CustomErrorForGetFollowers){
        switch error {
        case .userNotFound:
            let notFoundView = CustomInfoView(imageName: "person.fill.xmark", message: "User not found, Please try again.", emoji: "😔")
            notFoundView.frame = view.bounds
            view.addSubview(notFoundView)
        default: return
        }
        
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for specific follower..."
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
        if offsety > contentHeight - height{
            guard hasMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
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
        filteredFollowers = followers.filter{ $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: followers)
    }
}

extension FollowersListViewController: FollowersListViewControllerDelegate{
    func didSelectFollowers(for username: String) {
        self.username = username
        title = username
        followers.removeAll()
        filteredFollowers.removeAll()
        page = 1
        hasMoreFollowers = true
        collectionView.setContentOffset(.zero, animated: true)
        getFollowers(username: username, page: page)
    }
    
    
}
