//
//  CoreDataManagerTests.swift
//  GitHubAPITests
//
//  Created by Pratik on 20/08/20.
//  Copyright © 2020 Pratik. All rights reserved.
//

import XCTest
@testable import GitHubAPI

class CoreDataManagerTests: XCTestCase {
    
    var coreDataManager: CoreDataManager!
    
    override func setUp() {
        super.setUp()
        coreDataManager = CoreDataManager.shared
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    ///This test case test for the proper initialization of CoreDataManager class
    func testCoreDataManagerInitialization() {
        let instance = CoreDataManager.shared
        /*Asserts that an expression is not nil.
         Generates a failure when expression == nil.*/
        XCTAssertNotNil(instance)
    }
    
    /// NSPersistentContainer initialize or not
    func testCoreDataStackInitialization() {
        let coreDataStack = CoreDataManager.shared.persistentContainer
        
        /*Asserts that an expression is not nil.
         Generates a failure when expression == nil.*/
        XCTAssertNotNil(coreDataStack)
    }
    
}
