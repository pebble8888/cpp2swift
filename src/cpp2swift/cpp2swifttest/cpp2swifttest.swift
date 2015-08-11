//
//  cpp2swifttest.swift
//  cpp2swifttest
//
//  Created by pebble8888 on 2015/08/11.
//  Copyright (c) 2015年 pebble8888. All rights reserved.
//

import Cocoa
import XCTest

class cpp2swifttest: XCTestCase {
    var _parser = Parser()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test1() {
        XCTAssertEqual(
            _parser.parse("static OSStatus  Open (const CAComponent& inComp, CAAudioUnit &outUnit);"),
            "static func Open(inComp:CAComponent&, &outUnit:CAAudioUnit) -> OSStatus")
    }
    
    func test2() {
        XCTAssertEqual(
            _parser.parse("OSStatus  GlobalReset ()\n" +
                "{\n" +
                "return AudioUnitReset (AU(), kAudioUnitScope_Global, 0);\n" +
                "}\n" ),
            "func GlobalReset() -> OSStatus\n{\nreturn AudioUnitReset (AU(), kAudioUnitScope_Global, 0);\n}\n"
        )
    }
    
    func test3() {
        XCTAssertEqual(
            _parser.parse("const \tCAComponent& \t Comp() const { return mComp; }"),
                "func Comp() -> CAComponent&\n{ return mComp; }\n" )
    }
}
