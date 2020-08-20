//
//  UserDetailsDataService.swift
//  GitHubAPI
//
//  Created by Pratik on 20/08/20.
//  Copyright © 2020 Pratik. All rights reserved.
//

import Foundation

/// User details helper methods
protocol UserDetailsServiceProtocol: class {
    func fetchUserDetails(url : String, completion: @escaping ((Result<User, ErrorResult>) -> Void))
    func fetchUserFollowers(followersURL: String, userID: Int64?, completion: @escaping ((Result<[User], ErrorResult>) -> Void))
    func fetchLocalUserDetails(userID : Int64, completion: @escaping ((Result<UserPO, ErrorResult>) -> Void))
}

final class UserDetailsDataService: Parseable, UserDetailsServiceProtocol {
    static let shared = UserDetailsDataService()
    
    
    /// User details data fetch from server
    /// - Parameters:
    ///   - url: user profile url
    ///   - completion: User object
    func fetchUserDetails(url : String,
                          completion: @escaping ((Result<User, ErrorResult>) -> Void)) {
        let url = url
        let requestHelper = RequestHelper(url: url)
        ServerCommunication.sharedInstance.request(with: requestHelper) { (response) in
            guard let data = response.responseData else {
                completion(.failure(.custom(string: "File data found")))
                return
            }
            self.parse(User.self, from: data, userID: nil, completion: completion)
        }
    }
    
    /// Fetch user followers data
    /// - Parameters:
    ///   - followersURL: user followers url
    ///   - userID: user id
    ///   - completion: array of users
    func fetchUserFollowers(followersURL: String,
                            userID: Int64?,
                            completion: @escaping ((Result<[User], ErrorResult>) -> Void)) {
        let url = followersURL
        let requestHelper = RequestHelper(url: url)
        ServerCommunication.sharedInstance.request(with: requestHelper) { (response) in
            guard let data = response.responseData else {
                completion(.failure(.custom(string: "File data found")))
                return
            }
            self.parse([User].self, from: data, userID: userID, completion: completion)
        }
    }
    
    /// Fetch users list from local db
    /// - Parameters:
    ///   - userID: user id
    ///   - completion: user data
    func fetchLocalUserDetails(userID : Int64,
                               completion: @escaping ((Result<UserPO, ErrorResult>) -> Void)) {
        let predicate = NSPredicate(format: "id = %d", userID)
        if let objUser = CoreDataManager.shared.persistentContainer.viewContext.fetchData(entity: User.self,predicate: predicate).first as? User {
            var userPO = UserPO(fromUser: objUser)
            if let followers = objUser.has_followers?.allObjects as? [User], !followers.isEmpty {
                let followersPO = followers.map({UserPO(fromUser: $0)})
                userPO.arrayOfFollowers = followersPO
            }
            completion(.success(userPO))
        } else {
            completion(.failure(.parser(string: "User not found")))
        }
    }
}
