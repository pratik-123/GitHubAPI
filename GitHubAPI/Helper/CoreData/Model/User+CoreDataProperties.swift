//
//  User+CoreDataProperties.swift
//  GitHubAPI
//
//  Created by Pratik on 19/08/20.
//  Copyright © 2020 Pratik. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var login: String?
    @NSManaged public var id: Int64
    @NSManaged public var node_id: String?
    @NSManaged public var avatar_url: String?
    @NSManaged public var url: String?
    @NSManaged public var followers_url: String?
    @NSManaged public var type: String?
    @NSManaged public var score: Double
    @NSManaged public var name: String?
    @NSManaged public var location: String?
    @NSManaged public var email: String?
    @NSManaged public var bio: String?
    @NSManaged public var public_repos: Int64
    @NSManaged public var public_gists: Int64
    @NSManaged public var followers: Int64
    @NSManaged public var following: Int64
    @NSManaged public var has_followers: NSSet?

}

// MARK: Generated accessors for has_followers
extension User {

    @objc(addHas_followersObject:)
    @NSManaged public func addToHas_followers(_ value: User)

    @objc(removeHas_followersObject:)
    @NSManaged public func removeFromHas_followers(_ value: User)

    @objc(addHas_followers:)
    @NSManaged public func addToHas_followers(_ values: NSSet)

    @objc(removeHas_followers:)
    @NSManaged public func removeFromHas_followers(_ values: NSSet)

}
