//
//  ErrorResult.swift
//  GitHubAPI
//
//  Created by Pratik on 19/08/20.
//  Copyright © 2020 Pratik. All rights reserved.
//

import Foundation
enum ErrorResult: Error {
    case network(string: String)
    case parser(string: String)
    case custom(string: String)
}

enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}
