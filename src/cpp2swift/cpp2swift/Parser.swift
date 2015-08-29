//
//  Parser.swift
//  cpp2swift
//
//  Created by pebble8888 on 2015/08/11.
//  Copyright (c) 2015 pebble8888. All rights reserved.
//

import Foundation

class Parser :NSObject {
    var _functions:[Function] = []
    
    // function
    struct Function {
        var funcName:String!            ///< function name
        var returnTypeName:String!      ///< return type name of function, nil means 'Void'
        // function argument
        struct Arg {
            var typeName:String!        ///< the type name of the argument
            var varName:String!         ///< the variable name of the argument
            var output: String          ///< swift type definition string of the function argument
            {
                if let l_varName = varName {
                    if let l_typeName = typeName {
                        return l_varName + ":" + Function.convertType(l_typeName)
                    }
                }
                return ""
            }
        }
        //
        static func convertType(cppType:String) -> String
        {
            let typeCorrespondings = ["bool":"Bool",
                "int":"Int"]
            if let swiftType = typeCorrespondings[cppType] {
                return swiftType
            } else {
                return cppType
            }
        }
        var isStatic:Bool = false   ///< whether the function is static or not
        var args:[Arg] = []         ///< arguments of the function
        var body:String!            ///< implementation of the function
        
        var output: String          ///< swift function string
        {
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
                            return $0 + ",\n" + $1.output
                        }
                    })
                    str += addstr
                    str += ")"
                    if returnTypeName1 != "void" {
                        str += " -> " + Function.convertType(returnTypeName1)
                    }
                    if body != nil {
                        str += "\n{" + body + "}\n"
                    } else {
                        str += "\n"
                    }
                    return str
                }
            }
            return ""
        }
    }
    
    /**
     @param  string:String  C++ code string
     @return String         swift code String
     */
    func parse(string:String) -> String
    {
        for definition in CppHeaderSequence(text:string) {
            var function:Function = Function()
            function.body = definition.body
            parse_onefunction_and_push(definition.head!, function: &function)
            _functions.append(function)
        }
       
        return _functions.map({
            (function: Function) -> String in
                return function.output
            }).reduce("", combine: {
                if $0 == "" {
                    return $1
                } else {
                    return $0 + $1
                }
            })
    }
    
    /**
     @brief
     */
    func parse_onefunction_and_push(string:String, inout function:Function)
    {
        function.isStatic = (string.rangeOfString("static") != nil)
        let str2:String = string.stringByReplacingOccurrencesOfString("\n", withString:"")
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
            if sp2.count > 0 && sp2[0] == "void" {
                return
            }
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
    }
}
