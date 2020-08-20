//
//  UserSearchBaseModel.swift
//  GitHubAPI
//
//  Created by Pratik on 19/08/20.
//  Copyright © 2020 Pratik. All rights reserved.
//

import Foundation
struct UserSearchBaseModel : Codable {
    let total_count: Int
    let items: [User]
}
