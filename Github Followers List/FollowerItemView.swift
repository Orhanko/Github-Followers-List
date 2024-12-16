//
//  FollowerItemView.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/16/24.
//

import UIKit

class FollowerItemView: ItemInfoViewController {
    
    func configureItems(with user: User) {
        itemInfoViewOne.set(itemInfoType: .followers, with: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, with: user.following)
        button.configureItemInfoButton(title: "Get Followers", backgroundColor: .systemOrange)
    }
}
