//
//  FollowerItemView.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/16/24.
//

import UIKit

class FollowerItemInfoView: ItemInfoView {
    
    func configureItems() {
        itemInfoViewOne.set(itemInfoType: .followers, with: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, with: user.following)
        button.configureItemInfoButton(title: "Get Followers", backgroundColor: .systemOrange)
    }
    
    override func buttonTapped() {
        delegate.didTapGetFollowers(for: user)
    }
}
