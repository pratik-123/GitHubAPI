//
//  UserPO.swift
//  GitHubAPI
//
//  Created by Pratik on 20/08/20.
//  Copyright © 2020 Pratik. All rights reserved.
//

import Foundation
struct UserPO {
    let login: String?
    let id: Int64
    let node_id: String?
    let avatar_url: String?
    let url: String?
    let followers_url: String?
    let score: Double
    let name: String?
    let location: String?
    let email: String?
    let bio: String?
    var arrayOfFollowers: [UserPO]?
    init(fromUser user: User) {
        self.login = user.login
        self.id = user.id
        self.node_id = user.node_id
        self.avatar_url = user.avatar_url
        self.url = user.url
        self.followers_url = user.followers_url
        self.score = user.score
        self.name = user.name
        self.location = user.location
        self.email = user.email
        self.bio = user.bio
        self.arrayOfFollowers = []
    }
}
