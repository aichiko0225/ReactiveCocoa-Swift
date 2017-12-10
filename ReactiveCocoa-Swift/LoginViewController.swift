//
//  LoginViewController.swift
//  ReactiveCocoa-Swift
//
//  Created by Apple on 2017/12/8.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        bindViewModel()
        
    }
    
    func bindViewModel() {
        
        viewModel.username <~ usernameTextField.reactive.continuousTextValues.skipNil()
        viewModel.password <~ passwordTextField.reactive.continuousTextValues.skipNil()
        
        loginButton.reactive.isEnabled <~ viewModel.buttonEnabled
        viewModel.buttonEnabled <~ usernameTextField.reactive.continuousTextValues.skipNil().combineLatest(with: passwordTextField.reactive.continuousTextValues.skipNil()).map({$0.0.count > 0 && $0.1.count > 0})
        
        errorMessageLabel.reactive.text <~ viewModel.error
        
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
