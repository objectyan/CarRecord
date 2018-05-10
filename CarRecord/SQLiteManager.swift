//
//  SQLiteManager.swift
//  CarRecord
//
//  Created by Object Yan on 2018/5/9.
//  Copyright © 2018年 Object Yan. All rights reserved.
//

import Foundation
import SQLite

class SQLiteManager: NSObject {
    private static let instance = SQLiteManager()
    
    class var sharedManager:SQLiteManager {
        return instance
    }
    
    func openDB() -> Connection? {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        return try? Connection("\(path)/db.sqlite3")
    }

    let costType = Table("CostType")
    
}
