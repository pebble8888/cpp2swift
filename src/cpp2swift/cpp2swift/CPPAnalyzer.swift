//
//  CppAnalyzer.swift
//  cpp2swift
//
//  Created by pebble8888 on 2015/10/01.
//  Copyright © 2015年 pebble8888. All rights reserved.
//

import Foundation

enum CPPTokenType {
    case Enum           // enum定義                 ;の直前または{の直前まで
    case Struct         // struct定義               ;の直前または{の直前まで
    case Class          // クラス定義                ;の直前または{の直前まで
    case Comment        // ソースコメント              コメントの終わりまで
    case ExposeLevel    // クラス公開レベル指定       カンマまで
    case Method         // メソッド宣言, ()があること {}の部分は含まない   (の直前まで
    case Variable(info:VariableInfo)       // 変数宣言                 ;の直前まで
    case Preprocessor   // #で始まる                LFの直前まで
    case LBrace         // {
    case RBrace         // }
    //case LParen         // (
    //case RParen         // )
    //case Body           // {}で囲まれた部分
    case ClassInit      // クラス初期化指定子 ( クラス定義の後ろの : からカンマが終わるところまで ;の直前または{の直前まで
    case BlankLine      // 改行のみからなる行
    case RootBlock      // ルートブロック
    case Other          // その他
}

enum VariableType {
    case Normal
    case Pointer
    case Reference
    case DoublePointer
}

struct VariableInfo {
    var variableType:VariableType = .Normal
    var const:Bool = false
    var pointerConst:Bool = false
    var reference:Bool = false
    init()
    {
    }
}

// これがASTNodeの意味
class CPPNode: CustomStringConvertible {
    var tokenType:CPPTokenType
    var string:String
    init(tokenType:CPPTokenType, string:String = ""){
        self.tokenType = tokenType
        self.string = string
    }
    var description: String {
        return "\(tokenType) \(string)"
    }
}


class CPPAnalyzer {
    
    enum CPPError : ErrorType {
        case Invalid(String)
        case InvalidClassDefinition
    }
    
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
    var cppnodes:[CPPNode] = []
    var gen:TokenGenerator!
    
    func analyze(gen:TokenGenerator){
        self.cppnodes.removeAll()
        self.gen = gen
        
        do {
            while true {
                // コメント判定が最初
                let comment = try parseComment()
                if let t = comment {
                    cppnodes.append(t)
                    continue
                }
                
                let cur:Token = try gen.nextPeek()
                switch cur.type {
                case .LBrace:
                    let node = CPPNode(tokenType: .LBrace)
                    cppnodes.append(node)
                    try gen.next()
                    continue
                case .RBrace:
                    let node = CPPNode(tokenType: .RBrace)
                    cppnodes.append(node)
                    try gen.next()
                    continue
                    /*
                case .LParen:
                    let node = CPPNode(tokenType: .LParen)
                    cppnodes.append(node)
                case .RParen:
                    let node = CPPNode(tokenType: .RParen)
                    cppnodes.append(node)
                    */
                default:
                    break
                }
                let container = try parseContainer()
                if let t = container {
                    cppnodes.append(t)
                    continue
                }
                let exposelevel = try parseExposeLevel()
                if let t = exposelevel {
                    cppnodes.append(t)
                    continue
                }
                /*
                let method = parseMethod()
                if let t = method {
                    cppnodes.append(t)
                    continue
                }
                */
                
                //print("pos \(pos) \(tokenstack[pos])")
                //assert(false)
                let token = try gen.next()
                let t = CPPNode(tokenType: .Other, string: "\(token.type)")
                cppnodes.append(t)
            }
        } catch TokenGeneratorError.IndexError {
            //print("Index Error!")
            // 終了
        } catch {
            print("Error!")
        }
        for node in cppnodes {
            print("\(node)")
        }
    }
    func parseExposeLevel() throws -> CPPNode? {
        let cur:Token = try gen.nextPeek()
        switch cur.type {
        case .Word(let str):
            if str == "protected" ||
               str == "public" ||
               str == "private" 
            { 
                try gen.next()
                let t = try gen.next()
                switch t.type {
                case .Colon:
                    break
                default:
                    throw CPPError.Invalid("")
                }
            } else {
                return nil
            }
            return CPPNode(tokenType: .ExposeLevel, string: str) 
        default:
            break
        }
        return nil
    }
    // MARK: - 
    func parseContainer() throws -> CPPNode? {
        let cur:Token = try gen.nextPeek()
        switch cur.type {
        case .Word(let str):
            var node:CPPNode?
            if str == "struct" {
                node = CPPNode(tokenType: .Struct)
            } else if str == "class" {
                node = CPPNode(tokenType: .Class)
            } else if str == "enum" {
                node = CPPNode(tokenType: .Enum)
            } else {
                return nil
            }
            try gen.next()
            var i:Int = 0
            while true {
                let token = try gen.nextPeek(i)
                switch token.type {
                case .Word(let def):
                    node!.string = def
                case .LBrace:
                    assert(i >= 1)
                    try gen.next(i-1)
                    return node
                default:
                    print("\(token.pos)") 
                    throw CPPError.InvalidClassDefinition 
                }
                ++i
            }
        case .LF:
            assert(false)
        default: 
            break
        }
        return nil
    }
    
    func parseComment() throws -> CPPNode? {
        let cur:Token = try gen.nextPeek()
        switch cur.type {
        case .CommentOne:
            // 改行コードまでコメント
            let node:CPPNode = CPPNode(tokenType: .Comment)
            try gen.next()
            while true {
                let token = try gen.nextBare()
                switch token.type {
                case .LF:
                    node.string += token.type.asis
                    return node
                default:
                    node.string += token.type.asis
                }
            }
            assert(false)
            break
        case .CommentIn:
            // CommentOutまでコメント
            let node:CPPNode = CPPNode(tokenType: .Comment)
            try gen.next()
            while true {
                let token = try gen.nextBare()
                switch token.type {
                case .CommentOut:
                    node.string += token.type.asis
                    return node
                default:
                    node.string += token.type.asis
                }
            }
            assert(false)
            break
        default: 
            break
        }
        return nil
    }
    
}
