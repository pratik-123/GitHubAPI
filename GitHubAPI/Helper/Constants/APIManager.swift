//
//  APIManager.swift
//  GitHubAPI
//
//  Created by Pratik on 19/08/20.
//  Copyright © 2020 Pratik. All rights reserved.
//

import Foundation
struct APIManager {
    
    /// API base url
    static var baseURL: String {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            fatalError("Base url not found")
        }
        return baseURL
    }
    
    /// API end points
    struct APIEndPoint {
        static let users: String = APIManager.baseURL + "users"
        static let searchUsers: String = APIManager.baseURL + "search/users"
    }
}
