//
//  ViewController.swift
//  OnTheMap
//
//  Created by Layne Faler on 6/20/16.
//  Copyright © 2016 Layne Faler. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    // MARK: - Login State

    private enum LoginState { case Init, Idle, LoginWithUserPass, LoginWithFacebook }
    
    // MARK: Properties
    
    private let udacityClient = UdacityCilent.sharedClient()
    private let facebookClient = FacebookCilents.sharedClient()
    private let otmDataSource = OTMDataSource.sharedDataSource()
    
    // MARK: - Outlets
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        facebookClient.logout()
        configureUIForState(.Init)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if facebookClient.currentAccessToken() == nil {
            configureUIForState(.Idle)
        }
    }
    
    // MARK: Actions
    
    @IBAction func loginTapped(sender: AnyObject) {
        configureUIForState(.LoginWithUserPass)
        
        if emailTextfield.text!.isEmpty || passwordTextfield.text!.isEmpty {
            rejectWithError(AppConstants.Errors.UserPassEmpty)
        } else {
            udacityClient.loginWithUsername(emailTextfield.text!, password: passwordTextfield.text!) { (userKey, error) in
                dispatch_async(dispatch_get_main_queue()) {
                    if let userKey = userKey {
                        self.getStudentWithUserKey(userKey)
                    } else {
                        self.alertWithError(error!.localizedDescription)
                    }
                }
            }
        }
    }
    
    @IBAction func signUpTapped(sender: AnyObject) {
        if let signUpURL = NSURL(string: UdacityCilent.UdacityCommon.SignUpURL) where UIApplication.sharedApplication().canOpenURL(signUpURL) {
            UIApplication.sharedApplication().openURL(signUpURL)
        }
    }
    
    // GET Student Data
    
    private func getStudentWithUserKey(userKey: String) {
        udacityClient.studentWithUserKey(userKey) { (student, error) in
            dispatch_async(dispatch_get_main_queue()) {
                if let student = student {
                    self.otmDataSource.currentStudent = student
                    self.login()
                } else {
                    self.rejectWithError(error!.localizedDescription)
                }
            }
        }
    }
    
    // MARK: Login
    
    private func login() {
        performSegueWithIdentifier("login", sender: self)
    }
    
    // MARK: Configure UI
    
    private func configureUIForState(state: LoginState) {
        
        func startActivityIndicatorAndFade() {
            loginButton.enabled = false
            facebookLoginButton.enabled = false
            view.alpha = 0.5
        }
        
        switch(state) {
        case .Init:
            let backgroundGradient = CAGradientLayer()
            backgroundGradient.colors = [AppConstants.UI.LoginColorTop, AppConstants.UI.LoginColorBottom]
            backgroundGradient.locations = [0.0, 1.0]
            backgroundGradient.frame = view.frame
            view.layer.insertSublayer(backgroundGradient, atIndex: 0)
            facebookLoginButton.readPermissions = ["public_profile"]
            facebookLoginButton.delegate = self
        case .Idle:
            loginButton.enabled = true
            facebookLoginButton.enabled = true
            view.alpha = 1.0
        case .LoginWithUserPass:
            startActivityIndicatorAndFade()
        case .LoginWithFacebook:
            startActivityIndicatorAndFade()
            emailTextfield.text = ""
            passwordTextfield.text = ""
        }
    }
    
    // MARK: Display Error
    
    private func alertWithError(error: String) {
        configureUIForState(.Idle)
        let alertView = UIAlertController(title: AppConstants.Alerts.LoginTitle, message: error, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: AppConstants.AlertActions.Dismiss, style: .Cancel, handler: nil))
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    private func rejectWithError(error: String) {
        configureUIForState(.Idle)
        shakeUI()
        showAlert("\(error)", message: "\(error)")
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: title, style: .Default, handler: nil)
        alertController.addAction(action)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func shakeUI() {
        UIView.animateWithDuration(1.0) {
            let loginCenter = self.view.center
            let shake = CABasicAnimation(keyPath: "position")
            shake.duration = 0.1
            shake.repeatCount = 2
            shake.autoreverses = true
            shake.fromValue = NSValue(CGPoint: CGPointMake(loginCenter.x - 5, loginCenter.y))
            shake.toValue = NSValue(CGPoint: CGPointMake(loginCenter.x + 5, loginCenter.y))
            self.view.layer.addAnimation(shake, forKey: "position")
        }
    }
}

// MARK: - OTMLoginViewController: FBSDKLoginButtonDelegate

extension LoginViewController: FBSDKLoginButtonDelegate {
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        if facebookClient.currentAccessToken() == nil {
            configureUIForState(.LoginWithFacebook)
        }
        return true
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        func displayError(error: String) {
            self.facebookClient.logout()
            self.rejectWithError(error)
        }
        
        configureUIForState(.LoginWithFacebook)
        
        if let token = result.token.tokenString {
            udacityClient.loginWithFacebookToken(token) { (userKey, error) in
                dispatch_async(dispatch_get_main_queue()) {
                    if let userKey = userKey {
                        self.getStudentWithUserKey(userKey)
                    } else {
                        displayError(error!.localizedDescription)
                    }
                }
            }
        } else {
            displayError(error!.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        configureUIForState(.Idle)
    }
}