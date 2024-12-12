//
//  FollowersListViewController.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/10/24.
//

import UIKit

class FollowersListViewController: UIViewController {
    
    enum Section{
        case main
    }
//    let networkManager = NetworkManager()
    var followers: [Followers] = []
    var username: String = ""
    var page = 1
    var collectionView: UICollectionView!
    var hasMoreFollowers = true
    var loaderView: UIView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Followers>!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        showLoadinView()
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
                self?.updateData()
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
    
    func updateData(){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Followers>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { self.dataSource?.apply(snapshot, animatingDifferences: true) }
        
    }
    
    func showLoadinView(){
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
}
