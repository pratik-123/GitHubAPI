//
//  UserDetailsViewModelTests.swift
//  GitHubAPITests
//
//  Created by Pratik on 20/08/20.
//  Copyright © 2020 Pratik. All rights reserved.
//

import XCTest
@testable import GitHubAPI

class UserDetailsViewModelTests: XCTestCase {
    
    var viewModel : UserDetailsViewModel!
    fileprivate var service : MockUserDetailsService!
    
    override func setUp() {
        super.setUp()
        self.service = MockUserDetailsService()
        self.viewModel = UserDetailsViewModel(service: service)
    }
    
    override func tearDown() {
        self.viewModel = nil
        self.service = nil
        super.tearDown()
    }
    
    func testFetchWithNoService() {
        let expectation = XCTestExpectation(description: "No service found")
        // set service to nil
        viewModel.service = nil
        // expected error for no service found
        viewModel.onErrorHandling = { _ in
            expectation.fulfill()
        }
        viewModel.fetchData()
        
        wait(for: [expectation], timeout: 5.0)
    }
}

fileprivate class MockUserDetailsService: UserDetailsServiceProtocol {
    var objUser: User?
    
    func fetchUserDetails(url: String, completion: @escaping ((Result<User, ErrorResult>) -> Void)) {
        if let baseModel = objUser {
            completion(Result.success(baseModel))
        } else {
            completion(Result.failure(ErrorResult.custom(string: "No data found")))
        }
    }
    
    func fetchUserFollowers(followersURL: String, userID: Int64?, completion: @escaping ((Result<[User], ErrorResult>) -> Void)) {
        if let baseModel = objUser {
            completion(Result.success([baseModel]))
        } else {
            completion(Result.failure(ErrorResult.custom(string: "No data found")))
        }
    }
    
    func fetchLocalUserDetails(userID: Int64, completion: @escaping ((Result<UserPO, ErrorResult>) -> Void)) {
        if let baseModel = objUser {
            let userPO = UserPO(fromUser: baseModel)
            completion(Result.success(userPO))
        } else {
            completion(Result.failure(ErrorResult.custom(string: "No data found")))
        }
    }
}

