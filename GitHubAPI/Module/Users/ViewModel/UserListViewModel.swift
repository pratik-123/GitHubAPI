//
//  UserListViewModel.swift
//  GitHubAPI
//
//  Created by Pratik on 18/08/20.
//  Copyright © 2020 Pratik. All rights reserved.
//

import Foundation
class UserListViewModel {
    weak var service: UserListServiceProtocol?
    var onRefreshHandling : (() -> Void)?
    var onErrorHandling : ((ErrorResult?) -> Void)?
    private var arrayOfUsers = [UserPO]()
    
    init(service: UserListServiceProtocol = UserListDataService.shared) {
        self.service = service
    }
    
    
    /// reset data
    func resetData() {
        arrayOfUsers = []
        self.onRefreshHandling?()
    }
    
    /// Search user
    /// - Parameter text: serch text
    func searchUser(text: String) {
        if text.isEmpty {
            self.onRefreshHandling?()
            return
        }
        guard let service = service else {
            onErrorHandling?(ErrorResult.custom(string: "Missing service init"))
            return
        }
        ///check internet connectivity
        if ServerCommunication.isConnectedToInternet() {
            service.searchUser(text: text) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self.searchLocalUser(text: text, service: service)
                        break
                    case .failure(let error):
                        print(error)
                        self.onErrorHandling?(ErrorResult.network(string: error.localizedDescription))
                        break
                    }
                }
            }
        } else {
            self.searchLocalUser(text: text, service: service)
        }
    }
    
    /// Search user form local db
    /// - Parameters:
    ///   - text: search text
    ///   - service: service helper protocol
    func searchLocalUser(text: String, service: UserListServiceProtocol) {
        service.searchLocalUser(text: text) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.arrayOfUsers = data
                    self.onRefreshHandling?()
                    break
                case .failure(let error):
                    print(error)
                    self.onErrorHandling?(ErrorResult.network(string: error.localizedDescription))
                    break
                }
            }
        }
    }
}
extension UserListViewModel {
    
    /// number of users count return
    /// - Returns: users count
    func numberOfUser() -> Int {
        return arrayOfUsers.count
    }
    
    /// User object get
    /// - Parameter index: index
    /// - Returns: if index found then return user object otherwise nil
    func getUser(at index: Int) -> UserPO? {
        if arrayOfUsers.indices.contains(index) {
            return arrayOfUsers[index]
        }
        return nil
    }
}
