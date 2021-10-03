//
//  EntryPoint.swift
//  ThermoCheck
//
//  Created by Gabriel Medeiros Pelegrino on 02/10/2021.
//

import Foundation


class EntryPoint: FirebaseModel {
    let date: String
    let hour: String
    let temperature:Int
    let humidity:Int
 
    init(date:String, hour:String, temperature:Int, humidity:Int) {
        
        self.date = date
        self.hour = hour
        self.temperature = temperature
        self.humidity = humidity
    }
 
    var dict: [String : Any] {
        let dict: [String: Any] = ["date":date, "hour": hour, "temperature":temperature, "humidity":humidity]
        
        return dict
    }
    
    required init?(dict: [String : Any]) {
        guard let date = dict["date"] as? String,
              let hour = dict["hour"] as? String,
              let temperature = dict["temperature"] as? Int,
              let humidity = dict["humidity"] as? Int
        else {return nil}
        
        self.date = date
        self.hour = hour
        self.temperature = temperature
        self.humidity = humidity
    }
}

