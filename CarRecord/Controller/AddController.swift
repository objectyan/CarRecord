//
//  AddController.swift
//  CarRecord
//
//  Created by Object Yan on 2018/4/26.
//  Copyright © 2018年 Object Yan. All rights reserved.
//

import UIKit

class AddController: XLFormViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initializeForm()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeForm()
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
        
        row = XLFormRowDescriptor(tag: "Date", rowType: XLFormRowDescriptorTypeDate, title: "Date")
        row.value = Date()
        row.cellConfigAtConfigure["locale"] =  Locale.current
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "Time", rowType: XLFormRowDescriptorTypeTime, title: "Time")
        row.value = Date()
        row.cellConfigAtConfigure["locale"] =  Locale.current
        section.addFormRow(row)
        
        if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            row = XLFormRowDescriptor(tag: "Cost type", rowType: XLFormRowDescriptorTypeSelectorPopover, title: "Cost type")
        }else{
            row = XLFormRowDescriptor(tag: "Cost type", rowType: XLFormRowDescriptorTypeSelectorActionSheet, title: "Cost type")
        }
        row.selectorOptions = ["Oils", "Driving fee", "Maintenance", "Insurance and traffic", "Other"]
        row.value = "Oils"
        //row.action.formBlock = #selector(AddController.didTouchButton(_:))
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "Money", rowType: XLFormRowDescriptorTypeDecimal, title: "Money")
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "Remarks", rowType: XLFormRowDescriptorTypeTextView, title: "Remarks")
        section.addFormRow(row)
        
        sectionOil = XLFormSectionDescriptor.formSection(withTitle: "Oil Info")
        form.addFormSection(sectionOil)
        
        row = XLFormRowDescriptor(tag: "Mileage", rowType: XLFormRowDescriptorTypeDecimal, title: "Mileage")
        sectionOil.addFormRow(row)
        
        if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            row = XLFormRowDescriptor(tag: "Oil type", rowType: XLFormRowDescriptorTypeSelectorPopover, title: "Oil type")
        }else{
            row = XLFormRowDescriptor(tag: "Oil type", rowType: XLFormRowDescriptorTypeSelectorActionSheet, title: "Oil type")
        }
        row.selectorOptions = ["", "90#", "92#", "93#", "95#", "97#", "98#", "E92#", "E93#", "E95#", "E97#", "E98#", "0#", "-10#", "-20#", "-35#", "Gas"]
        sectionOil.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "Unit Price", rowType: XLFormRowDescriptorTypeDecimal, title: "Unit Price")
        sectionOil.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "Oil quantity", rowType: XLFormRowDescriptorTypeDecimal, title: "Oil quantity")
        sectionOil.addFormRow(row)
        
       
        
        self.form = form
    }
}
