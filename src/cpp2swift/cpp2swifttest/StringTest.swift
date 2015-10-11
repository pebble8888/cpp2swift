//
//  StringTest.swift
//  cpp2swift
//
//  Created by pebble8888 on 2015/09/30.
//  Copyright © 2015年 pebble8888. All rights reserved.
//

import XCTest

class StringTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testExample() {
        let s:String = "B1"
        XCTAssert( s[s.startIndex].isBigAlphabet() )
        let i:String.Index = s.startIndex.advancedBy(1)
        XCTAssert( !s[i].isAlphabet() )
    }

}
