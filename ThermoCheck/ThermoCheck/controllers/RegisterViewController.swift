//
//  RegisterViewController.swift
//  ThermoCheck
//
//  Created by Gabriel Medeiros Pelegrino on 30/09/2021.
//
import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        showProgress(title: "Signing you up...")
        guard let email = emailTextField.text, isEmailValid,
              let password = passwordTextField.text, isPasswordValid,
              let confirmPassword = confirmPasswordTextField.text, isPasswordValid,
              let username = usernameTextField.text, username.count > 1 else {
            return
        }
        
        guard password.elementsEqual(confirmPassword) else {
            return showError(title: "Check the Password Again.")
        }
        
        Authentication.shared.register(email: email, password: password, username: username) { (status, text) in
            if !status{
                self.showError(title: text)
            }else{
                Authentication.shared.login(email: email, password: password) { (status) in
                    if status{
                        DispatchQueue.main.async {
                            self.showSuccess(title: text)
                            Router.shared.toMain(viewController: self)
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.showError(title: "Try Login Again")
                            Router.shared.toLogin(viewController: self)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        Router.shared.toLogin(viewController: self)
    }
    

}

