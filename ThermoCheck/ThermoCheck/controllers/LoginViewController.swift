//
//  LoginViewController.swift
//  ThermoCheck
//
//  Created by Gabriel Medeiros Pelegrino on 30/09/2021.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class LoginViewController: UIViewController, LoginButtonDelegate {
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        showProgress(title: "Loggin...")
        Authentication.shared.loginWithFacebook { (status) in
            if status{
                DispatchQueue.main.async {
                    self.showSuccess(title: "")
                    Router.shared.toMain(viewController: self)
                }
            }else{
                DispatchQueue.main.async {
                    self.showError(title: "Some went wrong. Try Again")
                }
            }
        }
    }
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("logout")
    }
    
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButtons()
    }
    
    func setButtons(){
        let loginButtonFB = FBLoginButton()
        loginButtonFB.delegate = self
        loginButtonFB.permissions = ["public_profile", "email"]
        loginButtonFB.layer.cornerRadius = 10
        stack.insertArrangedSubview(loginButtonFB, at: 4)
        
        loginButton.layer.cornerRadius = 10
        createButton.layer.cornerRadius = 10
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, isEmailValid,
              let password = passwordTextField.text, isPasswordValid else {
                  return
              }
        
        sender.isEnabled = false //can't click Login twice
        showProgress(title: "Login...")
        
        Authentication.shared.login(email: email, password: password) { (status) in
            if status{
                DispatchQueue.main.async {
                    self.showSuccess(title: "")
                    Router.shared.toMain(viewController: self)
                }
            }else{
                DispatchQueue.main.async {
                    self.showError(title: "Something went wrong. Check the fields and Try Again")
                }
            }
        }
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        Router.shared.toRegister(viewController: self)
    }
    
}
