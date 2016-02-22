//
//  LoginViewController.swift
//  On the Map
//
//  Created by Adhemar Soria Galvarro on 25/1/16.
//  Copyright © 2016 Adhemar Soria Galvarro. All rights reserved.
//

import UIKit


class LoginViewController: BaseViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var viewFB: UIView!
    
    override func viewDidLoad() {
        loginButton.setTitle("Logging in....", forState: .Disabled)
        loginButton.setTitle("Log in", forState: .Normal)
        
        let loginView : FBSDKLoginButton = FBSDKLoginButton()
        viewFB.addSubview(loginView)
        let centerLoginX = (viewFB.bounds.width-loginView.bounds.width)/2
        loginView.center = CGPoint(x: centerLoginX, y: 20)
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
        loginView.delegate = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        checkIfAlreadyLogin()
    }
    
    func checkIfAlreadyLogin()
    {
        if (FBSDKAccessToken.currentAccessToken() != nil && UdacityClient.sharedInstance.sessionId == "")
        {
            
            let alertController = UIAlertController(title: "Login", message: "You already was login with FB Credentials as \(UdacityClient.sharedInstance.firstName)", preferredStyle: UIAlertControllerStyle.ActionSheet)
            alertController.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.Default)
                { action -> Void in
                    self.loginWithFacebook()
                    alertController.dismissViewControllerAnimated(true, completion: nil)
                })
            
            alertController.addAction(UIAlertAction(title: "LogOut", style: UIAlertActionStyle.Default)
                { action -> Void in
                    let loginManager = FBSDKLoginManager()
                    loginManager.logOut()
                    alertController.dismissViewControllerAnimated(true, completion: nil)
                })
            
            
            self.presentViewController(alertController, animated: true, completion: nil)

            
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        loginButton.layoutSubviews()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func didPressLogIn(sender: UIButton) {
        
        setFormState(true)
        if let username = emailTextField.text, password = passwordTextField.text {
            UdacityClient.sharedInstance.logIn(username, password: password) { (success, errorMessage) in
                self.setFormState(false, errorMessage: errorMessage)
                if success {
                    self.setFormState(false)
                    self.performSegueWithIdentifier("showTabs", sender: self)
                }
            }
        }
    }
    
    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            
            if (FBSDKAccessToken.currentAccessToken() != nil)
            {
                loginWithFacebook()
            }
        }
        
    }
    
    func loginWithFacebook(){
        UdacityClient.sharedInstance.logInWithFacebook(FBSDKAccessToken.currentAccessToken().tokenString) { (success, errorMessage) in
            self.setFormState(false, errorMessage: errorMessage)
            if success {
                self.setFormState(false)
                self.performSegueWithIdentifier("showTabs", sender: self)
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    private func setFormState(loggingIn: Bool, errorMessage: String? = nil) {
        emailTextField.enabled = !loggingIn
        passwordTextField.enabled = !loggingIn
        loginButton.enabled = !loggingIn
        if let message = errorMessage {
            showErrorAlert("Authentication Error", defaultMessage: message, errors: [])
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

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
