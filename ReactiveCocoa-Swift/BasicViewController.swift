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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // scopedExample()
        
        
        let viewModel = CCViewModel()
        viewModel.test()
        
        
        let label = UILabel(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        
        label.reactive.text <~ viewModel.username
        
        label.text = "2222"
        
        print(viewModel.username.value)
        
        self.view.addSubview(label)
        
        label.center = self.view.center
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            label.text = "3333"
            
            print(viewModel.username.value)
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
