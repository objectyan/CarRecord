//
//  CostController.swift
//  CarRecord
//
//  Created by Object Yan on 2018/4/26.
//  Copyright © 2018年 Object Yan. All rights reserved.
//

import UIKit
import Charts

class CostController: UIViewController, ChartViewDelegate {
    var chartView: BubbleChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initializeForm()
    }
    
    private func initializeForm(){
        chartView = BubbleChartView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height*0.75));
        self.view.addSubview(chartView)
        
    }
}
