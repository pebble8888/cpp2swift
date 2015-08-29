//
//  CppHeaderGenerator.swift
//
//  Created by pebble8888 on 2015/08/15.
//  Copyright (c) 2015 pebble8888. All rights reserved.
//

import Foundation

class CppHeaderGenerator : GeneratorType
{
    struct Paragraph:Printable {
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
    typealias Element = Paragraph // GeneratorTypeのプロトコル付属型を設定する
    
    private var _paragraphs: [Paragraph] = []
    
    func next() -> Element? {
        if _paragraphs.isEmpty {
            return nil
        }
        return _paragraphs.removeAtIndex(0)
    }
    
    /**
     @brief C++のヘッダファイル部のコードを関数単位で区切り、_paragraphsに分割してセットする。
     */
    init(text:String){
        
        let str:String = text
        
        var i:String.Index = str.startIndex
        var pin:String.Index = str.startIndex
        while i < str.endIndex {
            while i < str.endIndex {
                if str[i] == ";" {
                    
                    let r:Range = Range(start:pin, end:i)
                    let one = str.substringWithRange(r)
                    _paragraphs.append(Element(head: one))
                    
                    ++i
                    pin = i
                    
                    break
                } else if str[i] == "{" {
                    
                    let r:Range = Range(start:pin, end:i)
                    let one = str.substringWithRange(r)
                    
                    var definition:Paragraph = Paragraph(head:one)
                    
                    if let r = str.rangeOfString("}",
                        options: NSStringCompareOptions.LiteralSearch,
                        range:Range(start: i,end: str.endIndex))
                    {
                        definition.body = str.substringWithRange(Range(start: i.successor(), end: r.startIndex))
                        i = r.endIndex
                    } else {
                        // 対応する}が見つからずおかしいがここで一旦区切る。
                    }
                    _paragraphs.append(definition)
                    pin = i
                    break
                } else {
                    ++i
                }
            }
            if pin < i {
                let r:Range = Range(start:pin, end:i)
                let one = str.substringWithRange(r)
                _paragraphs.append(Element(head:one))
                pin = i
            }
        }
    }
}