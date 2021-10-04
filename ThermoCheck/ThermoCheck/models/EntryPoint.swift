//
//  EntryPoint.swift
//  ThermoCheck
//
//  Created by Gabriel Medeiros Pelegrino on 02/10/2021.
//

import Foundation


class EntryPoint: FirebaseModel {
    let dateTime: String
    let temperature:Int
    let humidity:Int
    
    init(dateTime:String, temperature:Int, humidity:Int) {
        
        self.dateTime = dateTime
        self.temperature = temperature
        self.humidity = humidity
    }
    
    var dict: [String : Any] {
        let dict: [String: Any] = ["dateTime":dateTime, "temperature":temperature, "humidity":humidity]
        
        return dict
    }
    
    required init?(dict: [String : Any]) {
        guard let dateTime = dict["dateTime"] as? String,
              let temperature = dict["temperature"] as? Int,
              let humidity = dict["humidity"] as? Int
        else {return nil}
        
        self.dateTime = dateTime
        self.temperature = temperature
        self.humidity = humidity
    }
}

