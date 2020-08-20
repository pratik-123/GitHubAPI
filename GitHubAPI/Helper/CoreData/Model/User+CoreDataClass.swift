//
//  User+CoreDataClass.swift
//  GitHubAPI
//
//  Created by Pratik on 19/08/20.
//  Copyright © 2020 Pratik. All rights reserved.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey {
        case login = "login"
        case id = "id"
        case node_id = "node_id"
        case avatar_url = "avatar_url"
        case url = "url"
        case followers_url = "followers_url"
        case type = "type"
        case score = "score"
        case name = "name"
        case location = "location"
        case email = "email"
        case bio = "bio"
        case public_repos = "public_repos"
        case public_gists = "public_gists"
        case followers = "followers"
        case following = "following"
    }
    required convenience public init(from decoder: Decoder) throws {
        guard let contextKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "User", in: managedObjectContext) else {
                fatalError("Failed to decode User")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.login = try? container.decode(String.self, forKey: .login)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.node_id = try? container.decode(String.self, forKey: .node_id)
        self.avatar_url = try? container.decode(String.self, forKey: .avatar_url)
        self.url = try? container.decode(String.self, forKey: .url)
        self.followers_url = try? container.decode(String.self, forKey: .followers_url)
        self.type = try? container.decode(String.self, forKey: .type)
        self.name = try? container.decode(String.self, forKey: .name)
        self.location = try? container.decode(String.self, forKey: .location)
        self.email = try? container.decode(String.self, forKey: .email)
        self.bio = try? container.decode(String.self, forKey: .bio)
        if let repo = try? container.decodeIfPresent(Int64.self, forKey: .public_repos) {
            self.public_repos = repo
        }
        if let gists = try? container.decodeIfPresent(Int64.self, forKey: .public_gists) {
            self.public_gists = gists
        }
        if let followers = try? container.decodeIfPresent(Int64.self, forKey: .followers) {
            self.followers = followers
        }
        if let following = try? container.decodeIfPresent(Int64.self, forKey: .following) {
            self.following = following
        }
        if let score = try? container.decodeIfPresent(Double.self, forKey: .score) {
            self.score = score
        }
        
        if let userKey = CodingUserInfoKey.user, let model = decoder.userInfo[userKey] as? User {
            addToHas_followers(model)
        }
    }
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
    }
}
