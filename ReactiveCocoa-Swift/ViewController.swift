//
//  ViewController.swift
//  ReactiveCocoa-Swift
//
//  Created by 24hmb on 2017/9/4.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class ViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var changeButton: UIButton!
    
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(nameLabel.reactive.text)
        
        let (signal, observer) = Signal<String, NSError>.pipe()
        
        signal.map { (text) -> Bool in
            return text.characters.count > 0
        }.observeCompleted {
            print("observeCompleted")
        }
        
        observer.sendCompleted()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func change(_ sender: Any) {
        
    }

}

