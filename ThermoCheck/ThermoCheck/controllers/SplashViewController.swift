//
//  SplashViewController.swift
//  ThermoCheck
//
//  Created by Gabriel Medeiros Pelegrino on 30/09/2021.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var cloudsImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cloudsImageView.center.x -= 100
        
        UIView.animate(withDuration: 3, delay: 0, options: .curveLinear) {[weak self] in
            self?.cloudsImageView.center.x += 100
        } completion: { status in
            Authentication.shared.fetchCurrentUser(viewController: self)
        }
    }
}
