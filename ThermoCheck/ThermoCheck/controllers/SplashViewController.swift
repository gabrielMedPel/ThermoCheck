//
//  SplashViewController.swift
//  ThermoCheck
//
//  Created by Gabriel Medeiros Pelegrino on 30/09/2021.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var cloudsImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var widthIcon: NSLayoutConstraint!
    @IBOutlet weak var heightIcon: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animateClouds()
        animateIcon()
    }
    
    func animateClouds(){
        cloudsImageView.center.x -= 100
        
        UIView.animate(withDuration: 3, delay: 0, options: .curveLinear) {[weak self] in
            self?.cloudsImageView.center.x += 100
        } completion: { [weak self] status in
            if let mself = self{
                Authentication.shared.fetchCurrentUser(viewController: mself)
            }
        }
    }
    
    func animateIcon(){
        iconImageView.alpha = 0
        
        heightIcon.constant -= 600
        widthIcon.constant -= 600
        
        
        UIView.animate(withDuration: 2, delay: 0, options: .curveLinear) {[weak self] in
            self?.iconImageView.alpha = 1
            self?.iconImageView.layoutIfNeeded()
        }
    }
}
