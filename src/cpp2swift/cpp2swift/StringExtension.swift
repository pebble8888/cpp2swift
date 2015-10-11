//
//  StringExtension.swift
//  cpp2swift
//
//  Created by pebble8888 on 2015/09/30.
//  Copyright © 2015年 pebble8888. All rights reserved.
//

import Foundation

extension Character {
    func isAlphabet() -> Bool       { return isSmallAlphabet()||isBigAlphabet() }
    func isSmallAlphabet() -> Bool  { return self >= "a" && self <= "z" }
    func isBigAlphabet() -> Bool    { return self >= "A" && self <= "Z" }
    func isNumber() -> Bool         { return self >= "0" && self <= "9" }
    func isUnderScore() -> Bool     { return self == "_" }
    func isKeyword() -> Bool        { return isAlphabet() || isUnderScore() }
    func isKeywordOrNumber() -> Bool{ return isKeyword() || isNumber() }
    func isSpace() -> Bool          { return self == " " }
    func isTab() -> Bool            { return self == "\t" }
    func isCR() -> Bool             { return self == "\r" }
    func isLF() -> Bool             { return self == "\n" }
    func isWhiteSpace() -> Bool     { return isSpace() || isTab() }
}

extension String {
    func isWord(begin:String.Index) -> String.Index {
        if begin.distanceTo(self.endIndex) > 0 {
            if !self[begin].isKeyword() { return begin }
            var i:String.Index = begin.advancedBy(1)
            for ; i < self.endIndex; ++i {
                if !self[i].isKeywordOrNumber() {
                    return i
                }
            }
            return i
        }
        return begin
    }
    
    func isLineFeed(begin:String.Index) -> String.Index {
        if begin.distanceTo(self.endIndex) > 0 {
            if self[begin].isLF() { return begin.advancedBy(1) }
            if begin.advancedBy(1) < self.endIndex {
                if self[begin].isCR() && self[begin.advancedBy(1)].isLF() {
                    return begin.advancedBy(2)
                }
            }
        }
        return begin
    }
    
    func isWhiteSpace(begin:String.Index) -> String.Index {
        if begin.distanceTo(self.endIndex) > 0 {
            if !self[begin].isWhiteSpace() { return begin }
            var i:String.Index = begin.advancedBy(1)
            for ; i < self.endIndex; ++i {
                if !self[i].isWhiteSpace() {
                    return i
                }
            }
            return i
        }
        return begin
    }
    
    func isThisString(begin:String.Index, str:String) -> String.Index {
        let len:Int = str.utf8.count
        if begin.distanceTo(self.endIndex) >= len {
            let end:String.Index = begin.advancedBy(len)
            let r:Range = Range(start:begin, end:end)
            let sig = self.substringWithRange(r)
            if sig == str {
                return end
            }
        }
        return begin
    }
    
    func isTwoColon(begin:String.Index) -> String.Index {
        return isThisString(begin, str: "::")
    }
    func isColon(begin:String.Index) -> String.Index {
        return isThisString(begin, str: ":")
    }
    func isSemicolon(begin:String.Index) -> String.Index {
        return isThisString(begin, str: ";")
    }
    func isPeriod(begin:String.Index) -> String.Index {
        return isThisString(begin, str: ".")
    }
    func isCamma(begin:String.Index) -> String.Index {
        return isThisString(begin, str: ",")
    }
    func isQuestion(begin:String.Index) -> String.Index {
        return isThisString(begin, str: "?")
    }
    func isAsterisk(begin:String.Index) -> String.Index {
        return isThisString(begin, str: "*")
    }
    func isTilde(begin:String.Index) -> String.Index {
        return isThisString(begin, str: "~")
    }
    func isSharp(begin:String.Index) -> String.Index {
        return isThisString(begin, str: "#")
    }
    func isCommentIn(begin:String.Index) -> String.Index {
        return isThisString(begin, str: "/*")
    }
    func isCommentOut(begin:String.Index) -> String.Index {
        return isThisString(begin, str: "*/")
    }
    func isCommentOne(begin:String.Index) -> String.Index {
        return isThisString(begin, str: "//")
    }
    func isLParen(begin:String.Index) -> String.Index {
        return isThisString(begin, str: "(")
    }
    func isRParen(begin:String.Index) -> String.Index {
        return isThisString(begin, str: ")")
    }
    func isLBrace(begin:String.Index) -> String.Index {
        return isThisString(begin, str: "{")
    }
    func isRBrace(begin:String.Index) -> String.Index {
        return isThisString(begin, str: "}")
    }
    func isLBracket(begin:String.Index) -> String.Index {
        return isThisString(begin, str: "[")
    }
    func isRBracket(begin:String.Index) -> String.Index {
        return isThisString(begin, str: "]")
    }
    func isOperand(begin:String.Index) -> String.Index {
        var i:String.Index
        i = isThisString(begin, str: "+"); if i != begin { return i }
        i = isThisString(begin, str: "-"); if i != begin { return i }
        i = isThisString(begin, str: "/"); if i != begin { return i }
        i = isThisString(begin, str: "!"); if i != begin { return i }
        i = isThisString(begin, str: "%"); if i != begin { return i }
        i = isThisString(begin, str: "~"); if i != begin { return i }
        i = isThisString(begin, str: "|"); if i != begin { return i }
        i = isThisString(begin, str: "||"); if i != begin { return i }
        i = isThisString(begin, str: "&&"); if i != begin { return i }
        return i
    }
    func isSQuatation(begin:String.Index) -> String.Index {
        return isThisString(begin, str: "'")
    }
    func isDQuatation(begin:String.Index) -> String.Index {
        return isThisString(begin, str: "\"")
    }
    func isEqual(begin:String.Index) -> String.Index {
        return isThisString(begin, str: "=")
    }
    func isAmpersand(begin:String.Index) -> String.Index {
        return isThisString(begin, str: "&")
    }
}
