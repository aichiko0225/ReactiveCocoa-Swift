//
//  BasicViewController.swift
//  ReactiveCocoa-Swift
//
//  Created by Apple on 2017/11/29.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

/// 一些基础知识的介绍
class BasicViewController: UIViewController {
    
    struct CCError: Error {
        var reason: String
    }
    
    let errorLabel: UILabel = UILabel()
    let sendButton: UIButton = UIButton(type: .custom)
    let phoneNumerTextField = UITextField()
    
    var errorText = MutableProperty("123")
    var phoneNumer = MutableProperty("222")
    
    var validPhoneNumber = ValidatingProperty<String, CCError>.init("") { (str) -> ValidatingProperty<String, BasicViewController.CCError>.Decision in
        return str.count == 11 ? .valid : .invalid(CCError(reason: "23333"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // scopedExample()
        
        self.view.addSubview(phoneNumerTextField)
        self.view.addSubview(errorLabel)
        self.view.addSubview(sendButton)
        
        phoneNumerTextField.frame.size = CGSize(width: 300, height: 44)
        phoneNumerTextField.center = self.view.center
        
        sendButton.frame = CGRect(x: 0, y: 500, width: 200, height: 44)
        sendButton.frame.origin.y = phoneNumerTextField.frame.origin.y + 80
        sendButton.center.x = phoneNumerTextField.center.x
        
        errorLabel.frame = CGRect(x: 0, y: 600, width: 200, height: 44)
        errorLabel.frame.origin.y = sendButton.frame.origin.y + 80
        errorLabel.center.x = phoneNumerTextField.center.x
        
        errorLabel.reactive.text <~ errorText
        sendButton.reactive.isEnabled <~ errorText.map({$0.count == 0})
        sendButton.reactive.backgroundColor <~ errorText.map{ $0.count == 0 ? UIColor.red : UIColor.gray } //只是演示一下什么都可以绑
        phoneNumerTextField.reactive.text <~ phoneNumer //绑定有效输入到输入框
        
        phoneNumer <~ phoneNumerTextField.reactive.continuousTextValues.map({ (text) -> String in
            if text?.count ?? 0 > 11 {
                let phoneNumer = (text ?? "").substring(to: (text?.index((text?.startIndex)!, offsetBy: 11))!) //1. 最多输入11个数字, 多余部分截掉
                let isValidPhoneNum = NSPredicate(format: "SELF MATCHES %@", "正则表达式...").evaluate(with: phoneNumer) //2. 检查手机格式是否正确
                self.errorText.value = isValidPhoneNum ? "" :"手机号格式不正确" //2. 格式不正确显示错误信息
                return phoneNumer //3. 返回截取后的有效输入
            }
            return text!
        })
        
        validPhoneNumber <~ phoneNumerTextField.reactive.continuousTextValues.skipNil()
        
        validPhoneNumber.signal.observe { (event) in
            print(event)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:  Signal 部分
    
    
    
    // MARK: SignalProducer 部分
    func scopedExample() {
        let producer = SignalProducer<Int, NoError> { (observer, lifetime) in
            observer.send(value: 2)
            observer.send(value: 1)
            observer.sendCompleted()
        }
        /*
        let observer1 = Signal<Int, NoError>.Observer { (event) in
            print("Subscriber 1 received \(event)")
        }
        let observer2 = Signal<Int, NoError>.Observer { (event) in
            print("Subscriber 2 received \(event)")
        }
        
        producer.start(observer1)
        producer.start(observer2)
        */
        
        producer.startWithValues { (value) in
            print(value)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
