//
//  AddController.swift
//  CarRecord
//
//  Created by Object Yan on 2018/4/26.
//  Copyright © 2018年 Object Yan. All rights reserved.
//

import UIKit

class AddController: XLFormViewController {
    
    fileprivate struct Tags {
        static let Date = "Date"
        static let Time = "Time"
        static let CostType = "CostType"
        static let Money = "Money"
        static let Remarks = "Remarks"
        static let Mileage = "Mileage"
        static let OilType = "OilType"
        static let UnitPrice = "UnitPrice"
        static let OilQuantity = "OilQuantity"
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initializeForm()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.savePressed(_:)))
    }
    
    @objc func savePressed(_ button: UIBarButtonItem)
    {
        let validationErrors : Array<NSError> = self.formValidationErrors() as! Array<NSError>
        if (validationErrors.count > 0){
            self.showFormValidationError(validationErrors.first, withTitle: "Error")
            return
        }
        self.tableView.endEditing(true)
        
        let alert = UIAlertController(title: "Valid Form", message: "No errors found!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func initializeForm() {
        // Implementation details covered in the next section.
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var sectionOil : XLFormSectionDescriptor
        var row: XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Add Record")
        section = XLFormSectionDescriptor.formSection(withTitle: "Base Info")
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: Tags.Date, rowType: XLFormRowDescriptorTypeDate, title: "Date")
        row.value = Date()
        row.isRequired = true
        row.cellConfigAtConfigure["locale"] =  Locale.current
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.Time, rowType: XLFormRowDescriptorTypeTime, title: "Time")
        row.value = Date()
        row.isRequired = true
        row.cellConfigAtConfigure["locale"] =  Locale.current
        section.addFormRow(row)
        
        if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            row = XLFormRowDescriptor(tag: Tags.CostType, rowType: XLFormRowDescriptorTypeSelectorPopover, title: "Cost type")
        }else{
            row = XLFormRowDescriptor(tag: Tags.CostType, rowType: XLFormRowDescriptorTypeSelectorActionSheet, title: "Cost type")
        }
        row.isRequired = true
        row.selectorOptions = ["Oils", "Driving fee", "Maintenance", "Insurance and traffic", "Other"]
        row.value = "Oils"
        //row.action.formBlock = #selector(AddController.didTouchButton(_:))
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.Money, rowType: XLFormRowDescriptorTypeDecimal, title: "Money")
        row.isRequired = true
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.Remarks, rowType: XLFormRowDescriptorTypeTextView, title: "Remarks")
        section.addFormRow(row)
        
        sectionOil = XLFormSectionDescriptor.formSection(withTitle: "Oil Info")
        sectionOil.hidden = "$\(Tags.CostType)!='Oils'"
        form.addFormSection(sectionOil)
        
        row = XLFormRowDescriptor(tag: Tags.Mileage, rowType: XLFormRowDescriptorTypeDecimal, title: "Mileage")
        row.isRequired = true
        sectionOil.addFormRow(row)
        
        if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            row = XLFormRowDescriptor(tag: Tags.OilType, rowType: XLFormRowDescriptorTypeSelectorPopover, title: "Oil type")
        }else{
            row = XLFormRowDescriptor(tag: Tags.OilType, rowType: XLFormRowDescriptorTypeSelectorActionSheet, title: "Oil type")
        }
        row.selectorOptions = ["", "90#", "92#", "93#", "95#", "97#", "98#", "E92#", "E93#", "E95#", "E97#", "E98#", "0#", "-10#", "-20#", "-35#", "Gas"]
         row.isRequired = true
        sectionOil.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.UnitPrice, rowType: XLFormRowDescriptorTypeDecimal, title: "Unit Price")
        row.isRequired = true
        sectionOil.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.OilQuantity, rowType: XLFormRowDescriptorTypeDecimal, title: "Oil quantity")
        row.isRequired = true
        sectionOil.addFormRow(row)
        
        self.form = form
    }
}
