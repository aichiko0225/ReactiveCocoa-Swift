//
//  CCTableViewController.swift
//  ReactiveCocoa-Swift
//
//  Created by Apple on 2017/12/12.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

class CCTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = CCTableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        typealias Task = (_ cancel: Bool) -> Void
        @discardableResult
        func delay(_ time: TimeInterval, task: @escaping () -> ()) -> Task? {
            func dispatch_later(block: @escaping ()->()) {
                let t = DispatchTime.now() + time
                DispatchQueue.main.asyncAfter(deadline: t, execute: block)
            }
            
            var closure: (()->Void)? = task
            var result: Task?
            
            let delayedClosure: Task = {
                cancel in
                if let internalClosure = closure {
                    if cancel == false {
                        DispatchQueue.main.async(execute: internalClosure)
                    }
                }
                closure = nil
                result = nil
            }
            result = delayedClosure
            dispatch_later {
                if let delayedClosure = result {
                    delayedClosure(false)
                }
            }
            return result
        }
        
        func cancel(_ task: Task?) {
            task?(true)
        }
        
        delay(2) { print("2 秒后输出") }
        
        let task = delay(5) { print("拨打 110") }
        
        // 仔细想一想..
        // 还是取消为妙..
        cancel(task)
        
    }
    
    private func configTableView() {
        tableView.tableFooterView = UIView()
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

extension CCTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows.value
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell(style: .default, reuseIdentifier: "cell")
    }
}
