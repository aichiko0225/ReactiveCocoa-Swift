//
//  SearchViewController.swift
//  ReactiveCocoa-Swift
//
//  Created by Apple on 2017/11/12.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result
import ReactiveCocoa

final class UserService {
    let (requestSignal, requestObserver) = Signal<String, NoError>.pipe()
    
    func canUseUsername(_ string: String) -> SignalProducer<Bool, NoError> {
        return SignalProducer({ (observer, disposable) in
            self.requestObserver.send(value: string)
            observer.send(value: true)
            observer.sendCompleted()
        })
    }
}

final class ViewModel {
    struct FormError: Error {
        let reason: String
        
        static let invalidEmail = FormError(reason: "The address must end with `@reactivecocoa.io`.")
        static let mismatchEmail = FormError(reason: "The e-mail addresses do not match.")
        static let usernameUnavailable = FormError(reason: "The username has been taken.")
    }
    
    let email: ValidatingProperty<String, FormError>
    let emailConfirmation: ValidatingProperty<String, FormError>
    let termsAccepted: MutableProperty<Bool>
    
    let submit: Action<(), (), FormError>
    
    let reasons: Signal<String, NoError>
    
    init(userService: UserService) {
        // email: ValidatingProperty<String, FormError>
        email = ValidatingProperty("") {
            input in
            return input.hasSuffix("@reactivecocoa.io") ? .valid : .invalid(.invalidEmail)
        }
        // emailConfirmation: ValidatingProperty<String, FormError>
        emailConfirmation = ValidatingProperty("", with: email) { input, email in
            return input == email ? .valid : .invalid(.mismatchEmail)
        }
        // termsAccepted: MutableProperty<Bool>
        termsAccepted = MutableProperty(false)
        // `validatedEmail` is a property which holds the validated email address if
        //  the entire form is valid, or it holds `nil` otherwise.
        //
        // The condition used in the `map` transform is:
        // 1. `emailConfirmation` passes validation: `!email.isInvalid`; and
        // 2. `termsAccepted` is asserted: `accepted`.
        // The action to be invoked when the submit button is pressed.
        //
        // Recall that `submit` is an `Action` with no input, i.e. `Input == ()`.
        // `Action` provides a special initializer in this case: `init(state:)`.
        // It takes a property of optionals — in our case, `validatedEmail` — and
        // would disable whenever the property holds `nil`.
        let validatedEmail: Property<String?> = Property
            .combineLatest(emailConfirmation.result, termsAccepted)
            .map { email, accepted -> String? in
                return !email.isInvalid && accepted ? email.value! : nil
        }
        submit = Action(unwrapping: validatedEmail) { (email: String) in
            let username = email
            
            return userService.canUseUsername(username)
                .promoteError(FormError.self)
                .attemptMap { Result<(), FormError>($0 ? () : nil, failWith: .usernameUnavailable) }
        }
        // `reason` is an aggregate of latest validation error for the UI to display.
        reasons = Property.combineLatest(email.result, emailConfirmation.result)
            .signal
            .debounce(0.1, on: QueueScheduler.main)
            .map { [$0, $1].flatMap { $0.error?.reason }.joined(separator: "\n") }
    }
    
}


class SearchViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var emailConfirmationField: UITextField!
    
    @IBOutlet weak var termsSwitch: UISwitch!
    
    @IBOutlet weak var reasonLabel: UILabel!
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let userService = UserService()
        let viewModel = ViewModel(userService: userService)
        
        emailField.text = viewModel.email.value
        emailConfirmationField.text = viewModel.emailConfirmation.value
        termsSwitch.isOn = false
        
        // Setup bindings with the interactive controls.
        
        viewModel.email <~ emailField.reactive.continuousTextValues.skipNil()
        
        viewModel.emailConfirmation <~ emailConfirmationField.reactive
            .continuousTextValues.skipNil()
        
        viewModel.termsAccepted <~ termsSwitch.reactive
            .isOnValues
        
        
        // Setup bindings with the invalidation reason label.
        reasonLabel.reactive.text <~ viewModel.reasons
        
        // Setup the Action binding with the submit button.
        submitButton.reactive.pressed = CocoaAction(viewModel.submit)
        
        // Setup console messages.
        userService.requestSignal.observeValues {
            print("UserService.requestSignal: Username `\($0)`.")
        }
        
        viewModel.submit.completed.observeValues {
            print("ViewModel.submit: execution producer has completed.")
        }
        
        viewModel.email.result.signal.observeValues {
            print("ViewModel.email: Validation result - \($0 != nil ? "\($0!)" : "No validation has ever been performed.")")
        }
        
        viewModel.emailConfirmation.result.signal.observeValues {
            print("ViewModel.emailConfirmation: Validation result - \($0 != nil ? "\($0!)" : "No validation has ever been performed.")")
        }
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
