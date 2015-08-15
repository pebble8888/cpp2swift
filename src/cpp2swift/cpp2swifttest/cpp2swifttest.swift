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
            "static func Open(inComp:CAComponent&, &outUnit:CAAudioUnit) -> OSStatus\n")
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
    
    func test4() {
        XCTAssertEqual(
            _parser.parse( "void function1(void);"),
            "func function1()\n"
        )
    }
    
    func test5() {
        XCTAssertEqual(
            _parser.parse(
            "void function1(void);\n" +
            "void function2(void){hoge;}\n" +
            "void function3(void){fuga;}\n" +
            "void function4(void);\n"),
            
            "func function1()\n" +
            "func function2()\n" +
            "{hoge;}\n" +
            "func function3()\n" +
            "{fuga;}\n" +
            "func function4()\n")
    }
}
