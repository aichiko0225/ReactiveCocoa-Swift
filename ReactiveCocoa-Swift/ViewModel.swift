//
//  ViewModel.swift
//  ReactiveCocoa-Swift
//
//  Created by Apple on 2017/11/30.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result
import ReactiveCocoa

class CCTableViewModel {
    struct CCError: Error {
        var reason: String
        
        static let noDataError = CCError(reason: "noData")
    }
    
    var numberOfRows: MutableProperty<Int> = MutableProperty(2)
}


class LoginViewModel {
    struct CCError: Error {
        
    }
    let username = ValidatingProperty<String, CCError>("") { (str) -> ValidatingProperty<String, CCError>.Decision in
        return str.count > 0 ? .valid : .invalid(CCError())
    }
    
    let password = ValidatingProperty<String, CCError>("") { (str) -> ValidatingProperty<String, CCError>.Decision in
        return str.count > 0 ? .valid : .invalid(CCError())
    }
    
    var error: Signal<String?, NoError>
    
    var buttonEnabled: MutableProperty<Bool> = MutableProperty(false)
    
    var action = Action<() ,String, NoError> { (input) -> SignalProducer<String, NoError> in
        print("input: ", input)
        return SignalProducer({ (obsever, _) in
            obsever.send(value: "2333")
            obsever.send(value: "66666")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                obsever.send(value: "77777")
                obsever.sendCompleted()
            })
        })
    }
    
    init() {
        error = Property.combineLatest(username.result, password.result)
            .signal
            .debounce(0.1, on: QueueScheduler.main)
            .map({ (usernameResult, passwordResult) -> String? in
                if usernameResult.isInvalid || passwordResult.isInvalid {
                    return nil
                }else {
                    return String.init(format: "username == %@ password == %@", usernameResult.value!, passwordResult.value!)
                }
        })
    }
}


class CCViewModel {
    
    struct CCError: Error {
        
    }
    
    let username: MutableProperty<String> = MutableProperty("")
    let password: MutableProperty<String> = MutableProperty("")
    
    func test() {
        let root = MutableProperty("Valid")
        
        let outer = ValidatingProperty(root, { $0 == "Valid" ? .valid : .invalid(CCError())})
        
        print(outer.result.value)
        
        root.value = "233"
        
        print(outer.result.value)
    }
    
    
    
}
