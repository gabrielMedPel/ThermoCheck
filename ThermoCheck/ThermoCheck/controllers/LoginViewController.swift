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
        if result?.isCancelled == true {
            return
        }
        showProgress(title: "Loggin...")
        Authentication.shared.loginWithFacebook {[weak self] (status) in
            if status{
                DispatchQueue.main.async {
                    self?.showSuccess(title: "")
                    if let mself = self{
                        Router.shared.toMain(viewController: mself)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self?.showError(title: "Some went wrong. Try Again")
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
        loginButtonFB.makeRounded()
        stack.insertArrangedSubview(loginButtonFB, at: 4)
        
        loginButton.makeRounded()
        createButton.makeRounded()
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
                DispatchQueue.main.async {[weak self] in
                    self?.showSuccess(title: "")
                    if let mself = self{
                        Router.shared.toMain(viewController: mself)
                    }
                }
            }else{
                DispatchQueue.main.async {[weak self] in
                    sender.isEnabled = true
                    self?.showError(title: "Something went wrong.", subtitle: "Check the fields and Try Again")
                }
            }
        }
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        Router.shared.toRegister(viewController: self)
    }
    
}
