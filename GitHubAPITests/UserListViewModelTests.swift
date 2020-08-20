//
//  UserListViewModelTests.swift
//  GitHubAPITests
//
//  Created by Pratik on 20/08/20.
//  Copyright © 2020 Pratik. All rights reserved.
//

import XCTest
@testable import GitHubAPI

class UserListViewModelTests: XCTestCase {
    
    var viewModel : UserListViewModel!
    fileprivate var service : MockUserListService!
    
    override func setUp() {
        super.setUp()
        self.service = MockUserListService()
        self.viewModel = UserListViewModel(service: service)
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
        viewModel.searchUser(text: "lorem")
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchWithData() {
        let expectation = XCTestExpectation(description: "List found")
        service.baseModel = UserSearchBaseModel(total_count: 1, items: [])
        // expected response
        viewModel.onRefreshHandling = { () in
            expectation.fulfill()
        }
        viewModel.searchUser(text: "lorem")
        wait(for: [expectation], timeout: 5.0)
    }
}

fileprivate class MockUserListService : UserListServiceProtocol {
    var  baseModel : UserSearchBaseModel?
    
    func searchUser(text: String, completion: @escaping ((Result<UserSearchBaseModel, ErrorResult>) -> Void)) {
        if let baseModel = baseModel {
            completion(Result.success(baseModel))
        } else {
            completion(Result.failure(ErrorResult.custom(string: "No data found")))
        }
    }
    
    func searchLocalUser(text: String, completion: @escaping ((Result<[UserPO], ErrorResult>) -> Void)) {
        completion(Result.success([]))
    }
}
