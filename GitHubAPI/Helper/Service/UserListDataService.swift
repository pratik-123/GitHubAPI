//
//  UserListDataService.swift
//  GitHubAPI
//
//  Created by Pratik on 19/08/20.
//  Copyright © 2020 Pratik. All rights reserved.
//

import Foundation

/// User list helper methods
protocol UserListServiceProtocol: class {
    func searchUser(text: String, completion: @escaping ((Result<UserSearchBaseModel, ErrorResult>) -> Void))
    func searchLocalUser(text: String, completion: @escaping ((Result<[User], ErrorResult>) -> Void))
}

final class UserListDataService: Parseable, UserListServiceProtocol {
    static let shared = UserListDataService()
    /// Search text to git user fetch
    /// - Parameters:
    ///   - text: search text
    ///   - completion: array of users
    func searchUser(text: String,
                    completion: @escaping ((Result<UserSearchBaseModel, ErrorResult>) -> Void)) {
        let url = APIManager.APIEndPoint.searchUsers + "?q=" + text
        let requestHelper = RequestHelper(url: url)
        ServerCommunication.sharedInstance.request(with: requestHelper) { (response) in
            guard let data = response.responseData else {
                completion(.failure(.custom(string: "File data found")))
                return
            }
            self.parse(UserSearchBaseModel.self, from: data, userID: nil, completion: completion)
        }
    }
    
    /// Search user from local db
    /// - Parameters:
    ///   - text: search text
    ///   - completion: array of users data
    func searchLocalUser(text: String,
                         completion: @escaping ((Result<[User], ErrorResult>) -> Void)) {
        let predicate = NSPredicate(format: "login CONTAINS[cd] %@", text)
        if let array = CoreDataManager.shared.persistentContainer.viewContext.fetchData(entity: User.self,predicate: predicate) as? [User] {
            completion(.success(array))
        } else {
            completion(.success([]))
        }
    }
}
