//
//  CppToken.swift
//  cpp2swift
//
//  Created by pebble8888 on 2015/10/04.
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
    case Macro          // #で始まる                LFの直前まで
    case LBrace         // {
    case RBrace         // }
    case LParen         // (
    case RParen         // )
    //case Body           // {}で囲まれた部分
    case ClassInit      // クラス初期化指定子 ( クラス定義の後ろの : からカンマが終わるところまで ;の直前または{の直前まで
    case BlankLine      // 改行のみの行
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

class CPPToken: CustomStringConvertible {
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

extension TokenStack {
    // 現在位置がWSでもLFでもなければそれを返す
    func nextNonWSLF(begin:Int) -> Int {
        var i = begin
        loop: for ; i < self.count; ++i {
            switch tokenTypeAtIndex(i) {
            case .WhiteSpace, .LF:
                break
            default:
                break loop
            }
        }
        return i
    }

    // MARK: - 単独のCPPTokenを戻す
    func isContainer(begin:Int) -> (CPPToken?, Int) {
        var i = begin
        var cpptoken:CPPToken?
        if i == self.count {
            return (nil, begin)
        }
        switch tokenTypeAtIndex(i) {
        case .Word(let str):
            if str == "struct" {
                cpptoken = CPPToken(tokenType: .Struct)
            } else if str == "enum" {
                cpptoken = CPPToken(tokenType: .Enum)
            } else if str == "class" {
                cpptoken = CPPToken(tokenType: .Class)
            } else {
                return (nil, begin)
            }
            ++i
            for ; i < self.count; ++i {
                switch tokenTypeAtIndex(i) {
                case .WhiteSpace, .LF: break
                case .Word(let def):
                    cpptoken!.string = def
                case .LBrace:
                    return (cpptoken, i)
                default: break
                }
            }
        default: break
        }
        return (nil,begin)
    }
    
    func isComment(begin:Int) -> (CPPToken?, Int) {
        var i = begin
        var cpptoken:CPPToken?
        if i == self.count {
            return (nil, begin)
        }
        let tt0 = tokenTypeAtIndex(i)
        switch tt0 {
        case .CommentIn:
            cpptoken = CPPToken(tokenType: .Comment, string: tt0.asis)
            ++i
            for ; i < self.count; ++i {
                let tt1 = tokenTypeAtIndex(i)
                switch tt1 {
                case .CommentOut:
                    cpptoken?.string += tt1.asis
                    ++i
                    return (cpptoken, i)
                default:
                    cpptoken?.string += tt1.asis
                }
            }
            assert(false)
        case .CommentOne:
            cpptoken = CPPToken(tokenType: .Comment, string: tt0.asis)
            ++i
            for ; i < self.count; ++i {
                let tt1 = tokenTypeAtIndex(i)
                switch tt1 {
                case .LF:
                    cpptoken!.string += tt1.asis
                    ++i
                    return (cpptoken, i)
                default:
                    cpptoken!.string += tt1.asis
                }
            }
            assert(false)
        default: break
        }
        return (nil, begin)
    }
    func isExposeLevel(begin:Int) -> (CPPToken?, Int) {
        var i = begin
        if i == self.count {
            return (nil, begin)
        }
        var cpptoken:CPPToken?
        let tt0 = tokenTypeAtIndex(i)
        switch tt0 {
        case .Word(let str):
            if str == "protected" ||
               str == "public" ||
               str == "private" {
                cpptoken = CPPToken(tokenType: .ExposeLevel, string: str)
                ++i
                for ; i < self.count; ++i {
                    let tt1 = tokenTypeAtIndex(i)
                    switch tt1 {
                    case .Colon:
                        ++i
                        return (cpptoken, i)
                    case .WhiteSpace, .LF:
                        break
                    default:
                        assert(false)
                    }
                }
            } else {
                break
            }
        default: break
        }
        return (nil, begin)
    }
    func isDelimiter(begin:Int) -> (CPPToken?, Int) {
        if begin == self.count {
            return (nil, begin)
        }
        let tt0 = tokenTypeAtIndex(begin)
        switch tt0 {
        case TokenType.LBrace:
            return (CPPToken(tokenType: .LBrace, string: "{"), begin+1)
        case TokenType.RBrace:
            return (CPPToken(tokenType: .RBrace, string: "}"), begin+1)
        case TokenType.LParen:
            return (CPPToken(tokenType: .LParen, string: "("), begin+1)
        case TokenType.RParen:
            return (CPPToken(tokenType: .RParen, string: ")"), begin+1)
        default:
            break
        }
        return (nil, begin)
        
    }
    func isMethod(begin:Int) -> (CPPToken?, Int) {
        var i = begin
        if i == self.count {
            return (nil, begin)
        }
        var cpptoken:CPPToken?
        let tt0 = tokenTypeAtIndex(i)
        switch tt0 {
        case .Word(let str):
            cpptoken = CPPToken(tokenType: .Method, string: str)
            ++i
            loop: for ; i < self.count; ++i {
                let tt1 = tokenTypeAtIndex(i)
                switch tt1 {
                case .WhiteSpace, .LF:
                    break
                case .LParen:
                    // メソッド確定
                    return (cpptoken, i)
                default:
                    break loop
                }
            }
        default: break
        }
        return (nil, begin)
    }
    func isVariable(begin:Int) -> (CPPToken?, Int) {
        var i = begin
        for ; i < self.count; ++i {
        }
        return (nil, begin)
    }
    func isMacro(begin:Int) -> (CPPToken?, Int) {
        var i = begin
        for ; i < self.count; ++i {
        }
        return (nil, begin)
    }
    func isBody(begin:Int) -> (CPPToken?, Int) {
        var i = begin
        for ; i < self.count; ++i {
        }
        return (nil, begin)
    }
    func isClassInit(begin:Int) -> (CPPToken?, Int) {
        var i = begin
        for ; i < self.count; ++i {
        }
        return (nil, begin)
    }
    func isBlankLine(begin:Int) -> (CPPToken?, Int) {
        var i = begin
        for ; i < self.count; ++i {
        }
        return (nil, begin)
    }
    
    // MARK : - 複数CPPTokenを戻す
    func inMethodParen(begin:Int) -> ([CPPToken], Int) {
        var cpptokens:[CPPToken] = []
        var i = begin
        if i == self.count {
            return (cpptokens, begin)
        }
        var cpptoken:CPPToken?
        let tt0 = tokenTypeAtIndex(i)
        switch tt0 {
            case .
        default:assert(false) // 実装不足
        }

        return (cpptokens, begin)
    }
}



class CPPTokenizer {
}