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
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            switch result{
            case .success(let followers):
                if followers.count < 15 {self?.hasMoreFollowers = false}
                self?.followers.append(contentsOf: followers)
                self?.updateData()
            case .failure(let error):
                print("Error: \(error)")
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
