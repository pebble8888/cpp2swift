//
//  Token.swift
//  cpp2swift
//
//  Created by pebble8888 on 2015/09/29.
//  Copyright © 2015年 pebble8888. All rights reserved.
//

import Foundation

struct Pos {
    var line  :UInt   // [1-]
    var column:UInt   // [1-]
    init(line:UInt, column:UInt){
        self.line = line
        self.column = column
    }
}

struct Token {
    var type:TokenType
    var pos :Pos
    init(type:TokenType, pos:Pos){
        self.type = type
        self.pos = pos
    }
}

enum TokenType {
    case Word(String)   //
    case TwoColon       // ::
    case CommentIn      // /*
    case CommentOut     // */
    case CommentOne     // //
    case WhiteSpace(String) //
    case LF(String)     // 改行
    case Colon          // :
    case Semicolon      // ;
    case Period         // .
    case Camma          // ,
    case Question       // ?
    case Asterisk       // *
    case Tilde          // ~
    case Sharp          // #
    case LParen         // (
    case RParen         // )
    case LBrace         // {
    case RBrace         // }
    case LBracket       // [
    case RBracket       // ]
    case SQuatation     // '
    case DQuatation     // "
    case Equal          // =
    case Ampersand      // &
    case Operand(String) // +,-,/,!,%,~,|,||,&&
    //case Less           // <
    //case Greater        // >
    //case TwoLess        // <<
    //case TwoGreater     // >>
    //case NumericInt(String)     // 整数値 3444
    //case NumericFloat(String)   // 小数点値 23.444f
    //case NumericHex(String)     // 16進数 0x11ff
    case Other(String)
    
    static func token(str:String, begin:String.Index) -> (TokenType, String.Index){
        return token(str, begin: begin, last: begin)
    }
    private static func token(str:String, begin:String.Index, last:String.Index) -> (TokenType, String.Index){
        // Other
        var i:String.Index = begin
        if i >= str.endIndex {
            // 確定
            let s:String = str.substringWithRange(Range(start: last, end: i))
            return (TokenType.Other(s), i)
        }
        // Word
        i = str.isWord(begin)
        if i != begin {
            let s:String = str.substringWithRange(Range(start: begin, end: i))
            return (TokenType.Word(s), i)
        }
        i = str.isTwoColon(begin);  if i != begin { return (TokenType.TwoColon, i) }
        i = str.isCommentIn(begin); if i != begin { return (TokenType.CommentIn, i) }
        i = str.isCommentOut(begin);if i != begin { return (TokenType.CommentOut, i) }
        i = str.isCommentOne(begin);if i != begin { return (TokenType.CommentOne, i) }
        i = str.isWhiteSpace(begin);
        if i != begin {
            let s:String = str.substringWithRange(Range(start: begin, end: i))
            return (TokenType.WhiteSpace(s), i)
        }
        i = str.isLineFeed(begin)
        if i != begin {
            let s:String = str.substringWithRange(Range(start: begin, end: i))
            return (TokenType.LF(s), i)
        }
        i = str.isColon(begin);     if i != begin { return (TokenType.Colon, i) }
        i = str.isSemicolon(begin); if i != begin { return (TokenType.Semicolon, i) }
        i = str.isPeriod(begin);    if i != begin { return (TokenType.Period, i) }
        i = str.isCamma(begin);     if i != begin { return (TokenType.Camma, i) }
        i = str.isQuestion(begin);  if i != begin { return (TokenType.Question, i) }
        i = str.isAsterisk(begin);  if i != begin { return (TokenType.Asterisk, i) }
        i = str.isTilde(begin);     if i != begin { return (TokenType.Tilde, i) }
        i = str.isSharp(begin);     if i != begin { return (TokenType.Sharp, i) }
        i = str.isLParen(begin);    if i != begin { return (TokenType.LParen, i) }
        i = str.isRParen(begin);    if i != begin { return (TokenType.RParen, i) }
        i = str.isLBrace(begin);    if i != begin { return (TokenType.LBrace, i) }
        i = str.isRBrace(begin);    if i != begin { return (TokenType.RBrace, i) }
        i = str.isLBracket(begin);  if i != begin { return (TokenType.LBracket, i) }
        i = str.isRBracket(begin);  if i != begin { return (TokenType.RBracket, i) }
        i = str.isSQuatation(begin);if i != begin { return (TokenType.SQuatation, i) }
        i = str.isDQuatation(begin);if i != begin { return (TokenType.DQuatation, i) }
        i = str.isEqual(begin);     if i != begin { return (TokenType.Equal, i) }
        i = str.isAmpersand(begin); if i != begin { return (TokenType.Ampersand, i) }
        i = str.isOperand(begin)
        if i != begin {
            let s:String = str.substringWithRange(Range(start: begin, end: i))
            return (TokenType.Operand(s), i)
        }
        // Otherの判定
        let j:String.Index = i.advancedBy(1)
        let t = token(str, begin: j, last: last)
        if t.1 == j {
            // NG
            return token(str, begin: j, last: last)
        } else {
            // このindexでOtherと判定できる
            return (TokenType.Other(str.substringWithRange(Range(start:last, end:j))), j)
        }
    }
    var asis: String {
        switch self {
        case Word(let str):   //
            return str
        case TwoColon:       // ::
            return "::"
        case CommentIn:      //
            return "/*"
        case CommentOut:     //
            return "*/"
        case CommentOne:     //
            return "//"
        case WhiteSpace(let str): //
            return str
        case LF(let str):     // 改行
            return str
        case Colon:          // :
            return ":"
        case Semicolon:      // ;
            return ";"
        case Period:         // .
            return "."
        case Camma:          // ,
            return ","
        case Question:       // ?
            return "?"
        case Asterisk:       // *
            return "*"
        case Tilde:          // ~
            return "~"
        case Sharp:          // #
            return "#"
        case LParen:         // (
            return "("
        case RParen:         // )
            return ")"
        case LBrace:         // {
            return "{"
        case RBrace:         // }
            return "}"
        case LBracket:       // [
            return "["
        case RBracket:       // ]
            return "]"
        case SQuatation:     // '
            return "'"
        case DQuatation:     // "
            return "\""
        case Equal:          // =
            return "="
        case Ampersand:      // &
            return "&"
        case Operand(let str): // +,-,/,!,%,~,|,||,&&
            return str
        //case Less           // <
        //case Greater        // >
        //case TwoLess        // <<
        //case TwoGreater     // >>
        //case NumericInt(String)     // 整数値 3444
        //case NumericFloat(String)   // 小数点値 23.444f
        //case NumericHex(String)     // 16進数 0x11ff
        case Other(let str):
            return str
        }
    }
}

class Tokenizer {
    var stack: [Token] = []
    func parse(str:String){
        var i:String.Index = str.startIndex
        var line:UInt = 1
        var col:UInt = 1
        while i < str.endIndex {
            let t = TokenType.token(str, begin: i)
            let token = Token(type: t.0, pos: Pos(line: line, column: col))
            stack.append(token)
            let prev:String.Index = i
            i = t.1
            switch t.0 {
            case TokenType.LF:
                ++line
                col = 1
            default:
                col += UInt(prev.distanceTo(i))
            }
        }
        
        // debug
        /*
        for t in stack {
            print("\(t.type)")
        }
        */
    }
}



enum TokenGeneratorError : ErrorType
{
    case IndexError
}

class TokenGenerator {
    private var stack:[Token] = []
    private var index: Int = 0
    init(stack:[Token]) {
        self.stack = stack
    }
    var currentIndex: Int {
        return index
    }
    func nextBare(stride:Int = 1) throws -> Token {
        if index + stride >= stack.count {
            throw TokenGeneratorError.IndexError 
        }
        let l_index:Int = index
        index += stride
        return stack[l_index]
    }
    func next(stride:Int = 1) throws -> Token {
        let token = try nextBare(stride) 
        switch token.type {
        case .WhiteSpace, .LF:
            return try next(stride)
        default:
            return token
        }
    }
    private func nextPeekBare(count:Int = 0) throws -> Token {
        if index + count >= stack.count {
            throw TokenGeneratorError.IndexError
        }
        return stack[index+count]
    }
    func nextPeek(count:Int = 0) throws -> Token {
        let token = try nextPeekBare(count)
        switch token.type {
        case .WhiteSpace, .LF:
            return try nextPeek(count+1)
        default:
            return token
        }
    }
}

