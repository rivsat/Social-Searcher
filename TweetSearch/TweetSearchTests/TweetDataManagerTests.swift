//
//  TweetDataManagerTests.swift
//  TweetSearch
//
//  Created by Tasvir H Rohila on 08/12/16.
//  Copyright © 2016 Tasvir H Rohila. All rights reserved.
//

import XCTest
@testable import TweetSearch

let kDefaultWaitForExpectationsWithTimeout = 10.0

class TweetDataManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetAccessToken() {
        let asyncExpectation = expectation(description: "TweetDataManagerTests async request")
        
        TweetDataManager.shared.getAccessToken(onSuccess: { (accessToken) in
            XCTAssert(accessToken.isEmpty == false)
            asyncExpectation.fulfill()
        }, onFailure: { (errorString) in
            XCTAssert(!errorString.isEmpty)
            print(errorString)
            asyncExpectation.fulfill()
    })
        self.waitForExpectations(timeout: kDefaultWaitForExpectationsWithTimeout) { error in
            XCTAssertNil(error, "TweetDataManagerTests: Could not download data")
        }
        
    }
    
}