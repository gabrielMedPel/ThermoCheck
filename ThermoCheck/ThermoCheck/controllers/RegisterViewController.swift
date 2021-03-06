//
//  RegisterViewController.swift
//  ThermoCheck
//
//  Created by Gabriel Medeiros Pelegrino on 30/09/2021.
//
import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButtons()
    }
    
    func setButtons(){
        backButton.layer.cornerRadius = 10
        signupButton.layer.cornerRadius = 10
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        showProgress(title: "Signing you up...")
        guard let email = emailTextField.text, isEmailValid else {return}
        guard let password = passwordTextField.text, isPasswordValid else {return}
        guard let confirmPassword = confirmPasswordTextField.text, isPasswordValid else {return}
        guard password.elementsEqual(confirmPassword) else {
            return showError(title: "Password didn't match. Try Again.")
        }
        
        Authentication.shared.register(email: email, password: password) {[weak self] (status, text) in
            if !status{
                self?.showError(title: text)
            }else{
                Authentication.shared.login(email: email, password: password) { (status) in
                    if status{
                        DispatchQueue.main.async {
                            self?.showSuccess(title: text)
                            if let mself = self{
                                Router.shared.toMain(viewController: mself)
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            self?.showError(title: "Try to login again.")
                            if let mself = self{
                                Router.shared.toLogin(viewController: mself)
                            }
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

