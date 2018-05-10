//
//  RecordController.swift
//  CarRecord
//
//  Created by Object Yan on 2018/4/26.
//  Copyright © 2018年 Object Yan. All rights reserved.
//

import UIKit

class RecordController: UITableViewController {
    
    var tableData:[AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        var cell = self.tableView.dequeueReusableCell(withIdentifier: "RecordCell")
        if(cell == nil){
            cell = UITableViewCell()
        }
        return cell!;
    }
}
