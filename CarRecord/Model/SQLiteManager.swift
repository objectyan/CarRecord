//
//  SQLiteManager.swift
//  CarRecord
//
//  Created by Object Yan on 2018/5/9.
//  Copyright © 2018年 Object Yan. All rights reserved.
//

import Foundation
import SQLite

struct Database {
    var db: Connection!
    
    init() {
        connectDatabase()
    }
    
    mutating func connectDatabase(filePath: String = "/Documents") -> Void {
        let sqlFilePath = NSHomeDirectory() + filePath + "/db.sqlite3"
        print(sqlFilePath)
        do {
            db = try Connection(sqlFilePath)
            print("Database Success")
        } catch {
            print("Database Error：\(error)")
        }
    }
    
    let TABLE_TYPE = Table("table_type")
    let TABLE_TYPE_NAME = Expression<String>("name")
    let TABLE_TYPE_VALUE = Expression<String>("value")
    let TABLE_TYPE_IS_SYSTEM = Expression<Int>("isSystem")
    let TABLE_TYPE_TYPE = Expression<String>("type")
    
    let TABLE_RECORD = Table("table_record")
    let TABLE_RECORD_ID = Expression<Int64>("id")
    let TABLE_RECORD_DATE = Expression<Date>("date")
    let TABLE_RECORD_TYPE = Expression<String>("type")
    let TABLE_RECORD_MONEY = Expression<Double>("money")
    let TABLE_RECORD_REMARK = Expression<String>("remark")
    
    let TABLE_RECORD_MAP = Table("table_record_map")
    let TABLE_RECORD_MAP_ID = Expression<Int64>("id")
    let TABLE_RECORD_MAP_KEY = Expression<String>("key")
    let TABLE_RECORD_MAP_VALUE = Expression<String>("value")
    let TABLE_RECORD_MAP_TYPE = Expression<String>("type")
    
    
    func tableCreate() -> Void {
        do {
            try db.run(TABLE_TYPE.create(ifNotExists: true) { table in
                table.column(TABLE_TYPE_NAME)
                table.column(TABLE_TYPE_TYPE)
                table.column(TABLE_TYPE_VALUE)
                table.column(TABLE_TYPE_IS_SYSTEM, defaultValue: 0)
                table.primaryKey(TABLE_TYPE_TYPE, TABLE_TYPE_VALUE)
            })
            
            try db.run(TABLE_RECORD.create(ifNotExists: true) { table in
                table.column(TABLE_RECORD_ID, primaryKey:true)
                table.column(TABLE_RECORD_DATE)
                table.column(TABLE_RECORD_TYPE)
                table.column(TABLE_RECORD_MONEY)
                table.column(TABLE_RECORD_REMARK)
            })
            
            try db.run(TABLE_RECORD_MAP.create(ifNotExists: true) { table in
                table.column(TABLE_RECORD_MAP_ID)
                table.column(TABLE_RECORD_MAP_KEY)
                table.column(TABLE_RECORD_MAP_VALUE)
                table.column(TABLE_RECORD_MAP_TYPE)
                table.primaryKey(TABLE_RECORD_MAP_ID, TABLE_RECORD_MAP_KEY)
            })
            
            tableInitData()
            print("Create Cost Type Success")
        } catch {
            print("Create Cost Type Error：\(error)")
        }
    }
    
    func tableInitData() -> Void {
        do {
            try db.run(TABLE_TYPE.insert(or: .replace, TABLE_TYPE_NAME <- "Oils", TABLE_TYPE_VALUE <- "Oils", TABLE_TYPE_IS_SYSTEM <- 1, TABLE_TYPE_TYPE <- "Cost"))
            try db.run(TABLE_TYPE.insert(or: .replace, TABLE_TYPE_NAME <- "Driving fee", TABLE_TYPE_VALUE <- "DrivingFee", TABLE_TYPE_IS_SYSTEM <- 1, TABLE_TYPE_TYPE <- "Cost"))
            try db.run(TABLE_TYPE.insert(or: .replace, TABLE_TYPE_NAME <- "Maintenance", TABLE_TYPE_VALUE <- "Maintenance", TABLE_TYPE_IS_SYSTEM <- 1, TABLE_TYPE_TYPE <- "Cost"))
            try db.run(TABLE_TYPE.insert(or: .replace, TABLE_TYPE_NAME <- "Insurance and traffic", TABLE_TYPE_VALUE <- "InsuranceAndTraffic", TABLE_TYPE_IS_SYSTEM <- 1, TABLE_TYPE_TYPE <- "Cost"))
            try db.run(TABLE_TYPE.insert(or: .replace, TABLE_TYPE_NAME <- "Other", TABLE_TYPE_VALUE <- "Other", TABLE_TYPE_IS_SYSTEM <- 1, TABLE_TYPE_TYPE <- "Cost"))
            
            try db.run(TABLE_TYPE.insert(or: .replace, TABLE_TYPE_NAME <- "90#", TABLE_TYPE_VALUE <- "90", TABLE_TYPE_IS_SYSTEM <- 1, TABLE_TYPE_TYPE <- "Oil"))
            try db.run(TABLE_TYPE.insert(or: .replace, TABLE_TYPE_NAME <- "92#", TABLE_TYPE_VALUE <- "92", TABLE_TYPE_IS_SYSTEM <- 1, TABLE_TYPE_TYPE <- "Oil"))
            try db.run(TABLE_TYPE.insert(or: .replace, TABLE_TYPE_NAME <- "93#", TABLE_TYPE_VALUE <- "93", TABLE_TYPE_IS_SYSTEM <- 1, TABLE_TYPE_TYPE <- "Oil"))
            try db.run(TABLE_TYPE.insert(or: .replace, TABLE_TYPE_NAME <- "95#", TABLE_TYPE_VALUE <- "95", TABLE_TYPE_IS_SYSTEM <- 1, TABLE_TYPE_TYPE <- "Oil"))
            try db.run(TABLE_TYPE.insert(or: .replace, TABLE_TYPE_NAME <- "97#", TABLE_TYPE_VALUE <- "97", TABLE_TYPE_IS_SYSTEM <- 1, TABLE_TYPE_TYPE <- "Oil"))
            try db.run(TABLE_TYPE.insert(or: .replace, TABLE_TYPE_NAME <- "98#", TABLE_TYPE_VALUE <- "98", TABLE_TYPE_IS_SYSTEM <- 1, TABLE_TYPE_TYPE <- "Oil"))
            try db.run(TABLE_TYPE.insert(or: .replace, TABLE_TYPE_NAME <- "E90#", TABLE_TYPE_VALUE <- "E90", TABLE_TYPE_IS_SYSTEM <- 1, TABLE_TYPE_TYPE <- "Oil"))
            try db.run(TABLE_TYPE.insert(or: .replace, TABLE_TYPE_NAME <- "E92#", TABLE_TYPE_VALUE <- "E92", TABLE_TYPE_IS_SYSTEM <- 1, TABLE_TYPE_TYPE <- "Oil"))
            try db.run(TABLE_TYPE.insert(or: .replace, TABLE_TYPE_NAME <- "E93#", TABLE_TYPE_VALUE <- "E93", TABLE_TYPE_IS_SYSTEM <- 1, TABLE_TYPE_TYPE <- "Oil"))
            try db.run(TABLE_TYPE.insert(or: .replace, TABLE_TYPE_NAME <- "E95#", TABLE_TYPE_VALUE <- "E95", TABLE_TYPE_IS_SYSTEM <- 1, TABLE_TYPE_TYPE <- "Oil"))
            try db.run(TABLE_TYPE.insert(or: .replace, TABLE_TYPE_NAME <- "E97#", TABLE_TYPE_VALUE <- "E97", TABLE_TYPE_IS_SYSTEM <- 1, TABLE_TYPE_TYPE <- "Oil"))
            try db.run(TABLE_TYPE.insert(or: .replace, TABLE_TYPE_NAME <- "E98#", TABLE_TYPE_VALUE <- "E98", TABLE_TYPE_IS_SYSTEM <- 1, TABLE_TYPE_TYPE <- "Oil"))
            try db.run(TABLE_TYPE.insert(or: .replace, TABLE_TYPE_NAME <- "0#", TABLE_TYPE_VALUE <- "0", TABLE_TYPE_IS_SYSTEM <- 1, TABLE_TYPE_TYPE <- "Oil"))
            try db.run(TABLE_TYPE.insert(or: .replace, TABLE_TYPE_NAME <- "-10#", TABLE_TYPE_VALUE <- "-10", TABLE_TYPE_IS_SYSTEM <- 1, TABLE_TYPE_TYPE <- "Oil"))
            try db.run(TABLE_TYPE.insert(or: .replace, TABLE_TYPE_NAME <- "-20#", TABLE_TYPE_VALUE <- "-20", TABLE_TYPE_IS_SYSTEM <- 1, TABLE_TYPE_TYPE <- "Oil"))
            try db.run(TABLE_TYPE.insert(or: .replace, TABLE_TYPE_NAME <- "-35#", TABLE_TYPE_VALUE <- "-35", TABLE_TYPE_IS_SYSTEM <- 1, TABLE_TYPE_TYPE <- "Oil"))
            try db.run(TABLE_TYPE.insert(or: .replace, TABLE_TYPE_NAME <- "Gas", TABLE_TYPE_VALUE <- "Gas", TABLE_TYPE_IS_SYSTEM <- 1, TABLE_TYPE_TYPE <- "Oil"))
            print("Init Cost Type Data Success")
        } catch {
            print("Init Cost Type Data Error：\(error)")
        }
    }
}
