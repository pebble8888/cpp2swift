//
//  cpp2swifttest_definition.swift
//  cpp2swift
//
//  Created by pebble8888 on 2015/08/15.
//  Copyright (c) 2015年 pebble8888. All rights reserved.
//

import Cocoa
import XCTest

class cpp2swifttest_definition: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func test1() {
        
        var str = "Hello;cat;hoge{mama}fuga{papa}dog;parot"
        
        var generator:CppHeaderGenerator = CppHeaderGenerator(text:str)
       
        var element:CppHeaderGenerator.Paragraph! = generator.next()
        while element != nil {
            println(element.description)
            element = generator.next()
        }
    }

}
