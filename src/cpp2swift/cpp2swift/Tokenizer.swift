//
//  Tokenizer.swift
//  cpp2swift
//
//  Created by pebble8888 on 2015/09/29.
//  Copyright © 2015年 pebble8888. All rights reserved.
//

import Foundation

class Tokenizer {
    var stack: [Token] = []
    func parse(str:String){
        var i:String.Index = str.startIndex
        var line:UInt = 1
        var col:UInt = 1
        while i < str.endIndex {
            let t = TokenType.token(str, begin: i)
            let token = Token(type: t.0, pos: Pos(line: line, column: col))
            stack.append(token)
            let prev:String.Index = i
            i = t.1
            switch t.0 {
            case TokenType.LF:
                ++line
                col = 1
            default:
                col += UInt(prev.distanceTo(i))
            }
        }
        
        // debug
        for t in stack {
            //print("\(t.type) \(t.pos)")
            //print("\(t.type)")
        }
    }
}