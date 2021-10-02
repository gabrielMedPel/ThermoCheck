//
//  FirebaseModel.swift
//  ThermoCheck
//
//  Created by Gabriel Medeiros Pelegrino on 02/10/2021.
//

import Foundation
 
protocol FirebaseModel {
    
    var dict: [String: Any]{get}
    
    init?(dict: [String: Any])
}


