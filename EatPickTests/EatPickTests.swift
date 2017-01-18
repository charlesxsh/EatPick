//
//  EatPickTests.swift
//  EatPickTests
//
//  Created by Shihao Xia on 1/8/17.
//  Copyright © 2017 Shihao Xia. All rights reserved.
//

import XCTest
@testable import EatPick

class EatPickTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let us = UserSetting.instance()
        us.set(value:"abc", ForKey key:.searchPreference.key)
        XCTAssertEqual(us.get<String>(ByKey: .searchPreference.key), "abc")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            let us = UserSetting.instance()
            us.set(value:"abc", ForKey key:UserSettingKey.searchPreference.key)

            // Put the code you want to measure the time of here.
        }
    }
    
}
