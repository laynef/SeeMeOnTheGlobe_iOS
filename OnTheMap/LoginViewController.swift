//
//  ViewController.swift
//  OnTheMap
//
//  Created by Layne Faler on 6/20/16.
//  Copyright © 2016 Layne Faler. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    enum LoginErrors: ErrorType {
        case noUsername
        case noPassword
    }
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeKeyboardNotification()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loginSegue" {
            do {
                if let username = emailTextfield.text, let password = passwordTextfield.text {
                    if username == "" {
                        throw LoginErrors.noUsername
                    }
                    
                    if password == "" {
                        throw LoginErrors.noPassword
                    }
                }
                segue.destinationViewController
            } catch LoginErrors.noUsername {
                showAlerts("No Username", message: "No username has been entered")
            } catch LoginErrors.noPassword {
                showAlerts("No Password", message: "No password has been entered")
            } catch let error {
                fatalError("\(error)")
            }
            
        }
    }
    
    

}

// MARK: - LoginViewController (Textfields)
extension LoginViewController {
    
    func keyboardWillShow(notification: NSNotification) {
        UIView.animateWithDuration(0.8) {
            
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.8) {
            
        }
    }
    
    private func subscribeKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private func unsubscribeKeyboardNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeight() -> CGFloat {
        
        return 0
    }
}

// MARK: - LoginViewController (Helper Methods)
extension LoginViewController {
    
    func showAlerts(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: title, style: .Default, handler: nil)
        alertController.addAction(action)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
}