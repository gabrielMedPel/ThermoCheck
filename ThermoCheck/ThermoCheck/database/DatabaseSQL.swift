//
//  DatabaseSQL.swift
//  ThermoCheck
//
//  Created by Gabriel Medeiros Pelegrino on 03/10/2021.
//

import SQLite
import Foundation

class DatabaseSQL {
    static let shared = DatabaseSQL()
    var db: Connection?
    private init(){
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let fileUrl = documentDirectory.appendingPathComponent("entryPoints").appendingPathExtension("sqlite3")
            
            db = try Connection(fileUrl.path)
            
        } catch {
            print("Creating Connection Error: \(error)")
        }
    }
    
    func createtable(){
        SQLCommands.createTable()
    }
    
}


