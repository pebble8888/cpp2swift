//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello;cat"

var i:String.Index = str.startIndex
var pin:String.Index = str.endIndex

while i < str.endIndex {
    while i < str.endIndex {
        if str[i] == ";" {
            break
        } else {
            ++i
        }
    }
    let aa = str.substringWithRange(Range(start:pin, end:i))
    
    pin = i
}
