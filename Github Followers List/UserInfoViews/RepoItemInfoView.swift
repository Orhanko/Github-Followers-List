//
//  RepoItemView.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/16/24.
//

import UIKit

class RepoItemInfoView: ItemInfoView {
    
    func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, with: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, with: user.publicGists)
        button.configureItemInfoButton(title: "Github Profile", backgroundColor: .systemPurple)
    }
    
    override func buttonTapped() {
        delegate.didTapGithubProfile(for: user)
    }
}
