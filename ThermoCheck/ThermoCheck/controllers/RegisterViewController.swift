//
//  RegisterViewController.swift
//  ThermoCheck
//
//  Created by Gabriel Medeiros Pelegrino on 30/09/2021.
//
import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        showProgress(title: "Signing you up...")
        guard let username = usernameTextField.text, isUsernameValid else {
            return showError(title: "Username not valid.", subtitle: "Must have more than 3 characters.")
        }
        guard let password = passwordTextField.text, isPasswordValid else {
            return showError(title: "Password not valid.", subtitle: "Must have at least 6 characters")
        }
        guard let confirmPassword = confirmPasswordTextField.text, isPasswordValid else {
            return
        }
        
        guard password.elementsEqual(confirmPassword) else {
            return showError(title: "Password didn't match. Try Again.")
        }
        
        Authentication.shared.register(email: username, password: password) { (status, text) in
            if !status{
                self.showError(title: text)
            }else{
                Authentication.shared.login(email: username, password: password) { (status) in
                    if status{
                        DispatchQueue.main.async {
                            self.showSuccess(title: text)
                            Router.shared.toMain(viewController: self)
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.showError(title: "Try to login again.")
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

