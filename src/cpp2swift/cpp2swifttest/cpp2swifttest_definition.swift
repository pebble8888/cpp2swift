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

    func testExample() {
        
        var str = "Hello;cat;hoge{mama}fuga{papa}dog;parot"
        
        var i:String.Index = str.startIndex
        var pin:String.Index = str.startIndex
        while i < str.endIndex {
            while i < str.endIndex {
                if str[i] == ";" {
                    ++i
                    break
                } else if str[i] == "{" {
                    if let r = str.rangeOfString("}",
                        options: NSStringCompareOptions.LiteralSearch,
                        range:Range(start: i,end: str.endIndex))
                    {
                        i = r.endIndex
                    } else {
                        // 対応する}が見つからずおかしいがここで一旦区切る。
                    }
                    break
                } else {
                    ++i
                }
            }
            let r:Range = Range(start:pin, end:i)
            let aa = str.substringWithRange(r)
            println( aa )
            pin = i
        }
    }


}
