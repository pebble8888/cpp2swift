//
//  CppAnalyzer.swift
//  cpp2swift
//
//  Created by pebble8888 on 2015/10/01.
//  Copyright © 2015年 pebble8888. All rights reserved.
//

import Foundation

class CPPAnalyzer {
    
    /*
    enum CPPElementType {
        case Root           // ルート
        case Enum           // enum定義                 ;の直前または{
        case Struct         // struct定義
        case ClassDef       // クラス定義                ;の直前または{の直前まで
        case Comment        // ソースコメント              コメントの終わりまで
        case ExposeLevel    // クラス公開レベル指定       カンマまで
        case MethodDef      // メソッド宣言, ()があること {}の部分は含まない   (の直前まで
        case VariableDef    // 変数宣言                 ;の直前まで
        case Macro          // #で始まる                LFの直前まで
        case Body           // {}で囲まれた部分
        case ClassInit      // クラス初期化指定子 ( クラス定義の後ろの : からカンマが終わるところまで 
                            //                        ;の直前または{の直前まで
        case BlankLine      // 改行のみの行
    }
    */

    
    func analyze(inout tokenstack:TokenStack){
        var cpptokens:[CPPToken] = []
        var i:Int = 0
        i = tokenstack.nextNonWSLF(i)
        while i < tokenstack.count {
            let container = tokenstack.isContainer(i)
            if let t = container.0 {
                cpptokens.append(t)
                i = container.1
                continue
            }
            let comment = tokenstack.isComment(i)
            if let t = comment.0 {
                cpptokens.append(t)
                i = comment.1
                continue
            }
            let exposelevel = tokenstack.isExposeLevel(i)
            if let t = exposelevel.0 {
                cpptokens.append(t)
                i = exposelevel.1
                continue
            }
            let delimiter = tokenstack.isDelimiter(i)
            if let t = delimiter.0 {
                cpptokens.append(t)
                i = delimiter.1
                continue
            }
            let method = tokenstack.isMethod(i)
            if let t = method.0 {
                cpptokens.append(t)
                i = method.1
                continue
            }
            
            //print("i \(i) \(tokenstack[i])")
            //assert(false)
            let t = CPPToken(tokenType: .Other, string: "\(tokenstack[i].type)")
            cpptokens.append(t)
            ++i
            i = tokenstack.nextNonWSLF(i)
        }
        for cpptoken in cpptokens {
            print("\(cpptoken)")
        }
    }
}
