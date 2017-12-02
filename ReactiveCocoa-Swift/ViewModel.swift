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
