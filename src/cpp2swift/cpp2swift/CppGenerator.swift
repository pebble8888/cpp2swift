//
//  CppGenerator.swift
//
//  Created by pebble8888 on 2015/08/15.
//  Copyright (c) 2015 pebble8888. All rights reserved.
//

import Foundation

class CppGenerator : GeneratorType
{
    struct Definition:Printable {
        var head:String?
        var body:String?
        init(head:String?, body:String? = nil){
            self.head = head
            self.body = body
        }
        var description:String
        {
            if let l_head = head {
                if let l_body = body {
                    return "head[\(l_head)] body[\(l_body)]"
                } else {
                    return "head[\(l_head)]"
                }
            } else {
                return "nothing"
            }
        }
    }
    typealias Element = Definition // GeneratorTypeのプロトコル付属型をDefinitionに設定する
    
    private var _definitions: [Definition] = []
    
    func next() -> Element? {
        if _definitions.isEmpty {
            return nil
        }
        return _definitions.removeAtIndex(0)
    }
    
    init(text:String){
        
        let str:String = text
        
        var i:String.Index = str.startIndex
        var pin:String.Index = str.startIndex
        while i < str.endIndex {
            while i < str.endIndex {
                if str[i] == ";" {
                    
                    let r:Range = Range(start:pin, end:i)
                    let one = str.substringWithRange(r)
                    _definitions.append(Element(head: one))
                    
                    ++i
                    pin = i
                    
                    break
                } else if str[i] == "{" {
                    
                    let r:Range = Range(start:pin, end:i)
                    let one = str.substringWithRange(r)
                    
                    var definition:Definition = Definition(head:one)
                    
                    if let r = str.rangeOfString("}",
                        options: NSStringCompareOptions.LiteralSearch,
                        range:Range(start: i,end: str.endIndex))
                    {
                        definition.body = str.substringWithRange(Range(start: i.successor(), end: r.startIndex))
                        i = r.endIndex
                    } else {
                        // 対応する}が見つからずおかしいがここで一旦区切る。
                    }
                    _definitions.append(definition)
                    pin = i
                    break
                } else {
                    ++i
                }
            }
            if pin < i {
                let r:Range = Range(start:pin, end:i)
                let one = str.substringWithRange(r)
                _definitions.append(Element(head:one))
                pin = i
            }
        }
    }
}