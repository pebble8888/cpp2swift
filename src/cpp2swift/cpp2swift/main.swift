//
//  main.swift
//  cpp2swift
//
//  Created by pebble8888 on 2015/08/11.
//  Copyright (c) 2015 pebble8888. All rights reserved.
//

import Foundation

struct Function {
    var funcName:String?
    var returnTypeName:String?      // nil means Void
    struct Arg {
        var typeName:String?
        var varName:String?
        var output: String {
            return varName! + ":" + typeName!
        }
    }
    var args:[Arg] = []
    var output: String {
        var str:String = "func " + funcName! + "("
        let addstr = args.reduce("", combine: {
            if $0 == "" {
                return $1.output
            } else {
                return $0 + ", " + $1.output
            }
        })
        str += addstr
        str += ") -> " + returnTypeName!
        return str
    }
}

if Process.argc != 1 {
    println( "Usage: cpp2swift" )
    exit(-1)
}

let standardInput = NSFileHandle.fileHandleWithStandardInput()
let inputData = standardInput.availableData

let inputString: NSString! = NSString(data: inputData, encoding: NSUTF8StringEncoding)
if inputString == nil {
    exit(-1)
}

let str:String = inputString as String!
let str1:String = str.stringByReplacingOccurrencesOfString("\n", withString:"")

let sp =
    split(str1, maxSplit: 256, allowEmptySlices: false,
        isSeparator: {(c:Character)->Bool in return c=="("||c==")"})

var function:Function = Function()

if sp.count >= 1 {
    let sp1 = split(sp[0], maxSplit: 256, allowEmptySlices: false,
        isSeparator: {(c:Character)->Bool in return c==" "})
    if sp1.count >= 1 {
        let el1 = sp1[0]
        let el11 = el1.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        function.returnTypeName = el11
    }
    if sp1.count >= 2 {
        let el1 = sp1[1]
        let el11 = el1.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        function.funcName = el11
    }
}

if sp.count >= 2 {
    let sp2 = split(sp[1], maxSplit: 256, allowEmptySlices: false,
        isSeparator: {(c:Character)->Bool in return c==","})
    for el2 in sp2 {
        let el21 = el2.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        var sp3 = split(el21, maxSplit: 256, allowEmptySlices: false,
            isSeparator: {(c:Character)->Bool in return c==" "})
        if sp3.count > 0 {
            var arg:Function.Arg = Function.Arg()
            arg.varName = sp3.last
            sp3.removeLast()
            let joint: String = sp3.reduce("", combine: {
                if $0 == "" { 
                    return $1 
                } else {
                    return $0 + " " + $1
                } 
            } )
            arg.typeName = joint
            function.args.append(arg)
        }
    }
}

println( function.output )

exit(0)

