//
//  CppHeaderSequence.swift
//
//  Created by pebble8888 on 2015/08/15.
//  Copyright (c) 2015年 pebble8888. All rights reserved.
//

import Foundation

class CppHeaderSequence: SequenceType {
    typealias Generator = CppHeaderGenerator
    func generate() -> CppHeaderGenerator {
        return CppHeaderGenerator(text: _text)
    }
    
    init(text:String)
    {
        self._text = text
    }
    private var _text:String
    
}
