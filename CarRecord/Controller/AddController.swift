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
    
    var database : Database!
    
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
        self.database = Database()
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
        var costTypeArr : [Any] = []
        for costType in (try! database.db.prepare(database.TABLE_TYPE.filter(database.TABLE_TYPE_TYPE.like("Cost")).order(database.TABLE_TYPE_IS_SYSTEM.desc))) {
            costTypeArr.append(XLFormOptionsObject(value: costType[database.TABLE_TYPE_VALUE], displayText: costType[database.TABLE_TYPE_NAME]))
        }
        row.selectorOptions = costTypeArr
        if(costTypeArr.count>0){
            row.value = costTypeArr[0]
        }
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.Money, rowType: XLFormRowDescriptorTypeDecimal, title: "Money")
        row.isRequired = true
        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.right.rawValue
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.Remarks, rowType: XLFormRowDescriptorTypeTextView, title: "Remarks")
        section.addFormRow(row)
        sectionOil = XLFormSectionDescriptor.formSection(withTitle: "Oil Info")
        sectionOil.hidden = "$\(Tags.CostType).formValue != 'Oils'"
        form.addFormSection(sectionOil)
        
        row = XLFormRowDescriptor(tag: Tags.Mileage, rowType: XLFormRowDescriptorTypeDecimal, title: "Mileage")
        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.right.rawValue
        row.isRequired = true
        sectionOil.addFormRow(row)
        
        if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            row = XLFormRowDescriptor(tag: Tags.OilType, rowType: XLFormRowDescriptorTypeSelectorPopover, title: "Oil type")
        }else{
            row = XLFormRowDescriptor(tag: Tags.OilType, rowType: XLFormRowDescriptorTypeSelectorActionSheet, title: "Oil type")
        }
        var oilTypeArr : [Any] = []
        for oilType in (try! database.db.prepare(database.TABLE_TYPE.filter(database.TABLE_TYPE_TYPE.like("Oil")).order(database.TABLE_TYPE_IS_SYSTEM.desc))) {
            oilTypeArr.append(XLFormOptionsObject(value: oilType[database.TABLE_TYPE_VALUE], displayText: oilType[database.TABLE_TYPE_NAME]))
        }
        row.selectorOptions = oilTypeArr
        row.isRequired = true
        if(oilTypeArr.count>0){
            row.value = oilTypeArr[0]
        }
        sectionOil.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.UnitPrice, rowType: XLFormRowDescriptorTypeDecimal, title: "Unit Price")
        row.isRequired = true
        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.right.rawValue
        sectionOil.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.OilQuantity, rowType: XLFormRowDescriptorTypeDecimal, title: "Oil quantity")
        row.isRequired = true
        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.right.rawValue
        sectionOil.addFormRow(row)
        
        self.form = form
    }
    
    var setControl : String!
    
    override func formRowDescriptorValueHasChanged(_ formRow: XLFormRowDescriptor!, oldValue: Any!, newValue: Any!) {
        super.formRowDescriptorValueHasChanged(formRow, oldValue: oldValue, newValue: newValue)
        if((self.form.formRow(withTag: Tags.CostType)?.value! as! XLFormOptionsObject).formValue as! String == "Oils" && newValue != nil && setControl != formRow.tag){
            var UnitPrice = self.form.formRow(withTag: Tags.UnitPrice)!;
            var Money = self.form.formRow(withTag: Tags.Money)!;
            var OilQuantity = self.form.formRow(withTag: Tags.OilQuantity)!;
            switch (formRow.tag){
            case Tags.Money:
                if(UnitPrice.value == nil && OilQuantity.value != nil){
                    setControl = Tags.UnitPrice
                    UnitPrice.value = (Float(Int( 100 * ( (Money.value as? Float ?? 0) / (OilQuantity.value as? Float ?? 1)) ))/100)
                    updateFormRow(UnitPrice)
                }else if(UnitPrice.value != nil && OilQuantity.value == nil){
                    setControl = Tags.OilQuantity
                    OilQuantity.value =  (Float(Int( 100 * ((Money.value as? Float ?? 0) / (UnitPrice.value as? Float ?? 1)) ))/100)
                    updateFormRow(OilQuantity)
                }
                break;
            case Tags.UnitPrice:
                if(Money.value == nil && OilQuantity.value != nil){
                    setControl = Tags.Money
                    Money.value = (Float(Int( 100 * ((UnitPrice.value as? Float ?? 0) * (OilQuantity.value as? Float ?? 0)) ))/100)
                    updateFormRow(Money)
                }else if(Money.value != nil){
                    setControl = Tags.OilQuantity
                    OilQuantity.value = (Float(Int( 100 * ((Money.value as? Float ?? 0) / (UnitPrice.value as? Float ?? 1)) ))/100)
                    updateFormRow(OilQuantity)
                }
                break;
            case Tags.OilQuantity:
                if(Money.value != nil){
                    setControl = Tags.UnitPrice
                    UnitPrice.value = (Float(Int( 100 * ((Money.value as? Float ?? 0) / (OilQuantity.value as? Float ?? 1)) ))/100)
                    updateFormRow(UnitPrice)
                }else if(UnitPrice.value != nil && Money.value == nil){
                    setControl = Tags.Money
                    Money.value = (Float(Int( 100 * ((OilQuantity.value as? Float ?? 0) * (UnitPrice.value as? Float ?? 0)) ))/100)
                    updateFormRow(Money)
                }
                break;
            default:
                break;
            }
            setControl = nil
        }
    }
}
