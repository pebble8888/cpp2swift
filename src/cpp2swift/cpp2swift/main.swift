//
//  main.swift
//  cpp2swift
//
//  Created by pebble8888 on 2015/08/11.
//  Copyright (c) 2015 pebble8888. All rights reserved.
//

import Foundation

if Process.argc != 1 {
    print("Usage: cpp2swift")
    exit(-1)
}

let g_standardInput = NSFileHandle.fileHandleWithStandardInput()
let g_inputData = g_standardInput.availableData

let g_inputString: NSString! = NSString(data: g_inputData, encoding: NSUTF8StringEncoding)
if g_inputString == nil {
    exit(-1)
}

let g_str:String = g_inputString as String!

//var g_parser:Parser = Parser()
//print(g_parser.parse(g_str))
var g_tokenizer = Tokenizer()
g_tokenizer.parse(g_str)
var g_cppAnalyzer = CPPAnalyzer()
//g_cppAnalyzer.analyze(g_tokenizer.stack)
g_cppAnalyzer.analyze(&g_tokenizer.stack)
