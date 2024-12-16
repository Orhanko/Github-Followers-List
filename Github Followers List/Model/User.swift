//
//  User.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/11/24.
//

import Foundation

class User: Codable {
    var login: String
    var avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    var publicRepos: Int
    var publicGists: Int
    var htmlUrl: String
    var followers: Int
    var following: Int
    var createdAt: String
}
