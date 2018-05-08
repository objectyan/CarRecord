//
//  ViewController.swift
//  CarRecord
//
//  Created by Object Yan on 2018/4/26.
//  Copyright © 2018年 Object Yan. All rights reserved.
//

import UIKit

class MainController:  UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.addChildVC(childVC: AnalysisController(), childTitle: "Analysis", imageName: "", selectedImageName: "")
        self.addChildVC(childVC: CostController(), childTitle: "Cost", imageName: "", selectedImageName: "")
        self.addChildVC(childVC: AddController(), childTitle: "Add Record", imageName: "", selectedImageName: "")
        self.addChildVC(childVC: RecordController(), childTitle: "Record", imageName: "", selectedImageName: "")
        self.addChildVC(childVC: SettingController(), childTitle: "Setting", imageName: "", selectedImageName: "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addChildVC(childVC: UIViewController, childTitle: String, imageName: String, selectedImageName:String)
    {
        let navigation = UINavigationController(rootViewController: childVC)
        childVC.title = childTitle
        childVC.tabBarItem.tag = 1
        childVC.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        childVC.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.withRenderingMode(.alwaysOriginal)
        // navigation.isNavigationBarHidden = true;
        self.addChildViewController(navigation)
    }
}

