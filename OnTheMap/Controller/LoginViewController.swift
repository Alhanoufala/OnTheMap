//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Alhanouf Alawwad on 01/12/1442 AH.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    @IBAction func loginTappedd(_ sender: UIButton){
        setLoggingIn(true)
        OTMClient.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "") { success, error in
            if success{
                self.setLoggingIn(false)
                self.performSegue(withIdentifier: "OnTheMap", sender: nil)
            }
            
            
            else{
                self.setLoggingIn(false)
                self.showFailure(message: error?.localizedDescription ?? "")
            }
        }
        
        
    }
    
    @IBAction func signUpTapped(_ sender: UIButton){
        openURL(OTMClient.Endpoints.signup.stringValue)
        
    }
    func setLoggingIn(_ loggingIn: Bool) {
        loggingIn ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        
        self.emailTextField.isEnabled = !loggingIn
        self.passwordTextField.isEnabled = !loggingIn
        self.loginButton.isEnabled = !loggingIn
        self.signUpButton.isEnabled = !loggingIn
        
        
    }
    
    
}




