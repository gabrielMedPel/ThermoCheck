//
//  DatabaseFB.swift
//  ThermoCheck
//
//  Created by Gabriel Medeiros Pelegrino on 02/10/2021.
//

import FirebaseDatabase

class DatabaseFB {
    
    static let shared = DatabaseFB()
    private init(){}
    
    func removeAll(callback: @escaping (Error?, Bool)->Void){
        EntryPoint.ref.child(Authentication.shared.getCurrentuserID()).removeValue() { (err, dbRef) in
            if let error = err{
                callback(error, false)
                return
            }
            callback(nil, true)
        }
    }
}

extension EntryPoint{
    
    static var ref: DatabaseReference{
        return Database.database().reference().child("users")
    }
    
    func save(callback: @escaping (Error?, Bool)->Void){
        EntryPoint.ref.child(Authentication.shared.getCurrentuserID()).child("entryPoints").childByAutoId().setValue(dict) { (err, dbRef) in
            if let error = err{
                callback(error, false)
                return
            }
            callback(nil, true)
        }
    }
}
