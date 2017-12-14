//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: [Next](@next)


let nums: [Int?] = [48, 99, nil]

let n = nums.flatMap {$0}

for score in n where score > 60 {
    print("及格啦 - \(score)")
}


class Node<T> {
    let value: T?
    let next: Node<T>?
    
    init(value: T?, next: Node<T>?) {
        self.value = value
        self.next = next
    }
}

let list = Node(value: 1,
            next: Node(value: 2,
                next: Node(value: 3,
                    next: Node(value: 4, next: nil))))


/*
@objc func callMe() {
    //...
}

@objc func callMeWithParam(obj: AnyObject!) {
    //...
}
*/
//let someMethod = #selector(callMe)
//let anotherMethod = #selector(callMeWithParam)

// 单例

class MyManager1 {
    class var shareManager: MyManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var staticInstance: MyManager = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.staticInstance = MyManager()
        }
        return Static.staticInstance!
    }
}

class MyManager2 {
    class var shareManager: MyManager2 {
        struct Static {
            static let staticInstance: MyManager2 = MyManager2()
        }
        return Static.staticInstance
    }
}

private let staticInstance: MyManager3 = MyManager3()
class MyManager3 {
    class var shareManager: MyManager3 {
        return staticInstance
    }
}

class MyManager4  {
    static let shared = MyManager4()
    private init() {}
}

class MyObject {
    var num = 0
}

var myObject = MyObject()
var a = [myObject]
var b = a

b.append(myObject)

myObject.num = 100
print(b[0].num)   //100
print(b[1].num)   //100

// myObject 的改动同时影响了 b[0] 和 b[1]


