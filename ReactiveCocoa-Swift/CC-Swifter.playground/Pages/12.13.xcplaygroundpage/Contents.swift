//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


// MARK: 字面量表达

let aNumber = 3
let aString = "Hello"
let aBool = true
/*
“Swift 为我们提供了一组非常有意思的协议，使用字面量来表达特定的类型。对于那些实现了字面量表达协议的类型，在提供字面量赋值的时候，就可以简单地按照协议方法中定义的规则“无缝对应”地通过赋值的方式将值表达为对应类型。这些协议包括了各个原生的字面量，在实际开发中我们经常可能用到的有：

ExpressibleByArrayLiteral
ExpressibleByBooleanLiteral
ExpressibleByDictionaryLiteral
ExpressibleByFloatLiteral
ExpressibleByNilLiteral
ExpressibleByIntegerLiteral
ExpressibleByStringLiteral”
*/

enum MyBool: Int {
    case ccTrue, ccFalse
}

extension MyBool: ExpressibleByBooleanLiteral {
    init(booleanLiteral value: Bool) {
        self = value ? .ccTrue : .ccFalse
    }
}

let myTrue: MyBool = true
let myFalse: MyBool = false

myTrue.rawValue    // 0
myFalse.rawValue   // 1


class Person: ExpressibleByStringLiteral {
    var name: String
    
    init(name value: String) {
        self.name = value
    }
    
    required convenience init(stringLiteral value: String) {
        self.init(name: value)
    }
    
    required convenience init(unicodeScalarLiteral value: String) {
        self.init(name: value)
    }
    
    required convenience init(extendedGraphemeClusterLiteral value: String) {
        self.init(name: value)
    }
}

let person: Person = "xiaoMing"
person.name

// MARK: 下标

extension Array {
    subscript(input: [Int]) -> ArraySlice<Element> {
        get {
            var result = ArraySlice<Element>()
            for i in input {
                assert(i < self.count, "Index out of range")
                result.append(self[i])
            }
            return result
        }
        set {
            for (index,i) in input.enumerated() {
                assert(i < self.count, "Index out of range")
                self[i] = newValue[index]
            }
        }
    }
}

var arr = [1, 2, 3, 4, 5]
arr[[0, 3, 4]]
arr[[0,2,3]] = [-1,-3,-4]
arr


