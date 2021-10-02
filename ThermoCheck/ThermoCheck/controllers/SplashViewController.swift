//
//  SplashViewController.swift
//  ThermoCheck
//
//  Created by Gabriel Medeiros Pelegrino on 30/09/2021.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        Authentication.shared.fetchCurrentUser(viewController: self)
        
    }

}
