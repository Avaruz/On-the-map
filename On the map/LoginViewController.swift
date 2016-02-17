//
//  LoginViewController.swift
//  On the Map
//
//  Created by Adhemar Soria Galvarro on 25/1/16.
//  Copyright © 2016 Adhemar Soria Galvarro. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        loginButton.setTitle("Logging in.... Please wait.", forState: .Disabled)
        loginButton.setTitle("Log in", forState: .Normal)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
        // The title was sticking in the "logging in..." state
        loginButton.layoutSubviews()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func didPressLogIn(sender: UIButton) {
        
        setFormState(true)
        if let username = emailTextField.text, password = passwordTextField.text {
            User.logIn(username, password: password) { (success, errorMessage) in
                self.setFormState(false, errorMessage: errorMessage)
                if success {
                    self.setFormState(false)
                    self.performSegueWithIdentifier("showTabs", sender: self)
                }
            }
        }
    }
    
    private func setFormState(loggingIn: Bool, errorMessage: String? = nil) {
        emailTextField.enabled = !loggingIn
        passwordTextField.enabled = !loggingIn
        loginButton.enabled = !loggingIn
        if let message = errorMessage {
            showErrorAlert("Authentication Error", defaultMessage: message, errors: [])
        }
    }

    /// Move between fields or hide the keyboard when return is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    // MARK: - Keyboard methods
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y = -getKeyboardHeight(notification)
    }

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }

    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
}
