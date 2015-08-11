//
//  Parser.swift
//  cpp2swift
//
//  Created by pebble8888 on 2015/08/11.
//  Copyright (c) 2015年 pebble8888. All rights reserved.
//

import Foundation

class Parser :NSObject {
    struct Function {
        var funcName:String!
        var returnTypeName:String!      // nil means Void
        struct Arg {
            var typeName:String!
            var varName:String!
            var output: String {
                if let l_varName = varName {
                    if let l_typeName = typeName {
                        return l_varName + ":" + l_typeName
                    }
                }
                return ""
            }
        }
        var isStatic:Bool = false
        var args:[Arg] = []
        var body:String!
        
        var output: String {
            if let funcName1 = funcName {
                if let returnTypeName1 = returnTypeName {
                    var str:String = ""
                    if isStatic {
                        str += "static "
                    }
                    str += "func " + funcName1 + "("
                    let addstr = args.reduce("", combine: {
                        if $0 == "" {
                            return $1.output
                        } else {
                            return $0 + ", " + $1.output
                        }
                    })
                    str += addstr
                    str += ") -> " + returnTypeName1
                    if body != nil {
                        str += "\n{" + body + "}\n"
                    }
                    return str
                }
            }
            return ""
        }
    }
    func parse(string:String) -> String
    {
        var function:Function = Function()
        
        let sp_comma = split(string, maxSplit: 256, allowEmptySlices: false,
            isSeparator: {(c:Character)->Bool in return c=="{"||c=="}"})
        if sp_comma.count >= 2 {
            function.body = sp_comma[1]
        }

        let str1:String = sp_comma[0]
        function.isStatic = (str1.rangeOfString("static") != nil)
        let str2:String = str1.stringByReplacingOccurrencesOfString("\n", withString:"")
        let str3:String = str2.stringByReplacingOccurrencesOfString("const", withString:"")
        let str4:String = str3.stringByReplacingOccurrencesOfString("\t", withString: " ")
        let str:String = str4.stringByReplacingOccurrencesOfString("static", withString:"")

        let sp = split(str, maxSplit: 256, allowEmptySlices: false,
            isSeparator: {(c:Character)->Bool in return c=="("||c==")"})

        if sp.count >= 1 {
            let sp1 = split(sp[0], maxSplit: 256, allowEmptySlices: false,
                isSeparator: {(c:Character)->Bool in return c==" "})
            if sp1.count >= 1 {
                let el = sp1[0]
                let el1 = el.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                function.returnTypeName = el1
            }
            if sp1.count >= 2 {
                let el = sp1[1]
                let el1 = el.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                function.funcName = el1
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
                    })
                    arg.typeName = joint
                    function.args.append(arg)
                }
            }
        }

        return function.output
    }
}
