//
//  SettingController.swift
//  CarRecord
//
//  Created by Object Yan on 2018/4/26.
//  Copyright © 2018年 Object Yan. All rights reserved.
//

import UIKit

class SettingController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad();
        self.tableView.tableFooterView = UIView()
    }
    
    var menus : [String] = ["Vehicle management","Display month","Cost type"]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        var cell = self.tableView.dequeueReusableCell(withIdentifier: "SettingCell")
        if(cell == nil){
            cell = UITableViewCell()
            cell?.textLabel?.text = menus[indexPath.item];
        }
        return cell!;
    }
}
