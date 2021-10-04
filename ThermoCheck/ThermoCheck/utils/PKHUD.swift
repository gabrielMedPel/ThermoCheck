//
//  PKHUD.swift
//  ThermoCheck
//
//  Created by Gabriel Medeiros Pelegrino on 30/09/2021.
//

import UIKit
import PKHUD

protocol ShowHUD{}
extension ShowHUD{
    func showProgress(title:String, subtitle: String? = nil){
        HUD.show(.labeledProgress(title: title, subtitle: subtitle))
    }
    
    func showError(title:String, subtitle: String? = nil){
        HUD.flash(.labeledError(title: title, subtitle: subtitle), delay: 2)
    }
    
    func showLabel(title:String){
        HUD.flash(.label(title), delay: 2)
    }
    
    func showSuccess(title:String, subtitle: String? = nil){
        HUD.flash(.labeledSuccess(title: title, subtitle: subtitle) ,delay: 1)
    }
}
extension UIViewController: ShowHUD{}

protocol UserValidation: ShowHUD {
    //1) you must have a TextField called emailTextField
    var emailTextField: UITextField!{get}
    var passwordTextField: UITextField!{get}
}

//client side validation (אין טעם לנסות משהו שברור שלא יעבוד)
extension UserValidation{
    
    var isEmailValid: Bool{
        //professional code for email checking
        guard emailTextField.isEmail() else {
            showError(title: "Email must be valid. Check and try again!")
            return false
        }
        return true
    }
    
    var isPasswordValid: Bool{
        guard let password = passwordTextField.text, password.count >= 6  else {
            showError(title: "Password must be at least 6 charters long")
            return false
        }
        return true
    }
}

extension LoginViewController: UserValidation{}
extension RegisterViewController: UserValidation{}
