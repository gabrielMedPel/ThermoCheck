//
//  Router.swift
//  ThermoCheck
//
//  Created by Gabriel Medeiros Pelegrino on 30/09/2021.
//

import UIKit

class Router{
    static let shared = Router()
    private init(){}
    
    func toMain(viewController: UIViewController){
        DispatchQueue.main.async {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main")
            viewController.presentInFullScreen(vc, animated: true)
        }
    }
    func toLogin(viewController: UIViewController){
        DispatchQueue.main.async {
            let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "login")
            viewController.presentInFullScreen(vc, animated: true)
        }
    }
    func toRegister(viewController: UIViewController){
        DispatchQueue.main.async {
            let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "register")
            viewController.presentInFullScreen(vc, animated: true)
        }
    }
}

