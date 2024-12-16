//
//  FollowerItemView.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/16/24.
//

import UIKit

class FollowerItemView: ItemInfoViewController {
    
    
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    func configureItems(with user: User) {
        itemInfoViewOne.set(itemInfoType: .followers, with: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, with: user.following)
        button.backgroundColor = .systemOrange
        button.setTitle("Github Profile", for: .normal)
    }
    func configureItemsProba(with broj: Int) {
        itemInfoViewOne.set(itemInfoType: .followers, with: broj)
        itemInfoViewTwo.set(itemInfoType: .following, with: broj)
        button.backgroundColor = .systemOrange
        button.setTitle("Github Profile", for: .normal)
    }
}
