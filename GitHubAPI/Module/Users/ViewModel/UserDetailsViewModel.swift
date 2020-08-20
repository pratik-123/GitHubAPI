//
//  UserDetailsViewModel.swift
//  GitHubAPI
//
//  Created by Pratik on 20/08/20.
//  Copyright © 2020 Pratik. All rights reserved.
//

import Foundation
class UserDetailsViewModel {
    var objUser: UserPO?
    weak var service: UserDetailsServiceProtocol?
    var onRefreshHandling : (() -> Void)?
    var onErrorHandling : ((ErrorResult?) -> Void)?
    
    init(service: UserDetailsServiceProtocol = UserDetailsDataService.shared) {
        self.service = service
    }
    
    /// Fetch user details and followers list
    func fetchData() {
        guard let service = service else {
            onErrorHandling?(ErrorResult.custom(string: "Missing service init"))
            return
        }
        ///check internet connectivity
        if ServerCommunication.isConnectedToInternet() {
            _ = Promise<Bool> { resolve,_  in
                ///First step user details get from server
                if let userURL = self.objUser?.url {
                    self.fetchUserDetails(url: userURL, service: service) {
                        resolve(true)
                    }
                } else {
                    resolve(true)
                }
            }
            .then { (_) in
                return Promise<Bool> { resolve,_  in
                    ///user followers details get from server
                    if let followersURL = self.objUser?.followers_url, let userID = self.objUser?.id  {
                        self.fetchUserFollowers(followersURL: followersURL, userID: userID, service: service) {
                            resolve(true)
                        }
                    } else {
                        resolve(true)
                    }
                }
            }
            .then { (_) in
                ///fetch users details from local db
                DispatchQueue.main.async {
                    self.fetchLocalUserDetails(service: service)
                }
            }
        } else {
            ///in internet connection not found then refresh screen
            self.fetchLocalUserDetails(service: service)
        }
    }
    
    /// Fetch user details from server
    /// - Parameters:
    ///   - url: user details url
    ///   - userID: user id
    ///   - service: service protocol
    private func fetchUserDetails(url: String, service: UserDetailsServiceProtocol, onCompletion : (() -> Void)?) {
        service.fetchUserDetails(url: url) { (_) in
            onCompletion?()
        }
    }
    
    /// Fetch user followers from server
    /// - Parameters:
    ///   - followersURL: followers url
    ///   - userID: user id
    ///   - service: service protocol
    private func fetchUserFollowers(followersURL: String, userID: Int64, service: UserDetailsServiceProtocol, onCompletion : (() -> Void)?) {
        service.fetchUserFollowers(followersURL: followersURL, userID: userID) { (_) in
            onCompletion?()
        }
    }
    
    /// Fetch user details from local db
    /// - Parameter service: service protocol
    private func fetchLocalUserDetails(service: UserDetailsServiceProtocol) {
        if let userID = objUser?.id {
            service.fetchLocalUserDetails(userID: userID) { (result) in
                switch result {
                case .success(let objUser):
                    self.objUser = objUser
                    self.onRefreshHandling?()
                    break
                case .failure(let error):
                    print(error)
                    self.onErrorHandling?(ErrorResult.network(string: error.localizedDescription))
                    break
                }
            }
        } else {
            onErrorHandling?(ErrorResult.custom(string: "User not found"))
        }
    }
}
extension UserDetailsViewModel {
    
    /// number of users count return
    /// - Returns: users count
    func numberOfUser() -> Int {
        guard let arrayOfUsers = objUser?.arrayOfFollowers else { return 0 }
        return arrayOfUsers.count
    }
    
    /// User object get
    /// - Parameter index: index
    /// - Returns: if index found then return user object otherwise nil
    func getUser(at index: Int) -> UserPO? {
        guard let arrayOfUsers = objUser?.arrayOfFollowers else { return nil }
        if arrayOfUsers.indices.contains(index) {
            let obj = arrayOfUsers[index]
            return obj
        }
        return nil
    }
}
