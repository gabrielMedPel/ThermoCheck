//
//  UIViewController+extensions.swift
//  ThermoCheck
//
//  Created by Gabriel Medeiros Pelegrino on 30/09/2021.
//

import UIKit
extension UIViewController {
    func presentInFullScreen(_ viewController: UIViewController,
                             animated: Bool,
                             completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: animated, completion: completion)
        }
    }
    
}
