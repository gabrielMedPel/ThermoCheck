//
//  SQLCommands.swift
//  ThermoCheck
//
//  Created by Gabriel Medeiros Pelegrino on 03/10/2021.
//

import Foundation
import SQLite

class SQLCommands {
    static var table = Table("entryPoint")
    
    static let dateTime = Expression<String>("dateTime")
    static let temperature = Expression<Int>("temperature")
    static let humidity = Expression<Int>("humidity")
    
    static func createTable(){
        guard let db = DatabaseSQL.shared.db else {
            print("DataBase Connection Error")
            return
        }
        
        do {
            try db.run(table.create(ifNotExists: true) { t in
                t.column(dateTime)
                t.column(temperature)
                t.column(humidity)
            })
        } catch  {
            print("\(error)")
        }
    }
    static func insert(_ entryPoint: EntryPoint) -> Bool?{
        guard let db = DatabaseSQL.shared.db else {
            print("DataBase Connection Error")
            return nil
        }
        
        do {
            try db.run(table.insert(dateTime <- entryPoint.dateTime, temperature <- entryPoint.temperature, humidity <- entryPoint.humidity))
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    static func getEntryPoints() -> [EntryPoint]?{
        guard let db = DatabaseSQL.shared.db else {
            print("DataBase Connection Error")
            return nil
        }
        
        var entryPoints = [EntryPoint]()
        
        do {
            for entryPoint in try db.prepare(table){
                let entryPoint = EntryPoint(dateTime: entryPoint[dateTime], temperature: entryPoint[temperature], humidity: entryPoint[humidity])
                
                entryPoints.append(entryPoint)
                
            }
        } catch  {
            print(error)
        }
        return entryPoints
    }
    
    static func clearEntrypoints(){
        guard let db = DatabaseSQL.shared.db else {
            print("DataBase Connection Error")
            return
        }
        
        do {
            try db.run(table.delete())
            
        } catch {
            print(error)
        }
    }
}
