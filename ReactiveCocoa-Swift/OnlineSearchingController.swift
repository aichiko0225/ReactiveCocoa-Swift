//
//  OnlineSearchingController.swift
//  ReactiveCocoa-Swift
//
//  Created by Apple on 2017/11/12.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result
import ReactiveCocoa

class OnlineSearchingController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let searchStrings = textField.reactive.continuousTextValues.throttle(0.5, on: QueueScheduler.main).logEvents()
        
        let searchResults = searchStrings.flatMap(.latest) { (query) -> SignalProducer<(Data, URLResponse), AnyError> in
            let request = self.makeSearchRequest(escapedQuery: query)
            return URLSession.shared.reactive
                .data(with: request).retry(upTo: 2)
                .flatMapError({ (error) in
                    print("Network error occurred: \(error)")
                    return SignalProducer.empty
                })
        }.map { (data, response) -> String in
                return ""
        }.observe(on: UIScheduler.init())
        
        searchResults.observe { (event) in
            switch event {
            case let .value(results):
            print("Search results: \(results)")
                break
            case let .failed(error):
                print("Search error: \(error)")
                break
            case .completed, .interrupted:
                break
            }
        }
    }
    
    func makeSearchRequest(escapedQuery: String?) -> URLRequest {
        return URLRequest.init(url: URL.init(string: "http://www.baidu.com")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
