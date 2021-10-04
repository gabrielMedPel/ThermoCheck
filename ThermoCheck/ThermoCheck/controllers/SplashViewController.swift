//
//  SplashViewController.swift
//  ThermoCheck
//
//  Created by Gabriel Medeiros Pelegrino on 30/09/2021.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leadingConstraint.constant = 0
        // TODO 3

        UIView.animate(withDuration: 3) { [weak self] in
          self?.view.layoutIfNeeded()
        } completion: { status in
            Authentication.shared.fetchCurrentUser(viewController: self)
        }
        

       
        
    }

}
