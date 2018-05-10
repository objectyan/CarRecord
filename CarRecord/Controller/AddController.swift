//
//  AddController.swift
//  CarRecord
//
//  Created by Object Yan on 2018/4/26.
//  Copyright © 2018年 Object Yan. All rights reserved.
//

import UIKit
import SQLite

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
    
    func animateCell(_ cell: UITableViewCell) {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values =  [0, 20, -20, 10, 0]
        animation.keyTimes = [0, NSNumber(value: 1 / 6.0), NSNumber(value: 3 / 6.0), NSNumber(value: 5 / 6.0), 1]
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.isAdditive = true
        cell.layer.add(animation, forKey: "shake")
    }
    
    @objc func savePressed(_ button: UIBarButtonItem)
    {
        let validationErrors : Array<NSError> = self.formValidationErrors() as! Array<NSError>
        if (validationErrors.count > 0){
            self.showFormValidationError(validationErrors.first, withTitle: "Error")
            for errorItem in validationErrors {
                let validationStatus : XLFormValidationStatus = errorItem.userInfo[XLValidationStatusErrorKey] as! XLFormValidationStatus
                if let rowDescriptor = validationStatus.rowDescriptor,
                    let indexPath = form.indexPath(ofFormRow: rowDescriptor),
                    let cell = tableView.cellForRow(at: indexPath) {
                    self.animateCell(cell)
                }
            }
            return
        }
        self.tableView.endEditing(true)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var date = dateFormatter.string(from: self.formValues()["Date"] as! Date)
        dateFormatter.dateFormat = " HH:mm:ss"
        date = date + dateFormatter.string(from: self.formValues()["Time"] as! Date)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var title = "Save", message = "Success.";
        
        do {
            try database.db.transaction {
                let rowid = try database.db.run(database.TABLE_RECORD.insert(
                    database.TABLE_RECORD_TYPE <- (self.formValues()[Tags.CostType] as! XLFormOptionsObject).formValue as! String,
                    database.TABLE_RECORD_DATE <- dateFormatter.date(from: date) ?? Date(),
                    database.TABLE_RECORD_REMARK <- (self.formValues()[Tags.Remarks] as? String) ?? "",
                    database.TABLE_RECORD_MONEY <- self.formValues()[Tags.Money] as! Double
                ))
                if(((self.formValues()[Tags.CostType] as! XLFormOptionsObject).formValue as! String) == "Oils"){
                    try database.db.run(database.TABLE_RECORD_MAP.insert(
                        database.TABLE_RECORD_MAP_ID <- rowid,
                        database.TABLE_RECORD_MAP_KEY <- Tags.Mileage,
                        database.TABLE_RECORD_MAP_VALUE <- String.init(format: "%@", self.formValues()[Tags.Mileage]! as! CVarArg),
                        database.TABLE_RECORD_MAP_TYPE <- "Double"
                    ))
                    
                    try database.db.run(database.TABLE_RECORD_MAP.insert(
                        database.TABLE_RECORD_MAP_ID <- rowid,
                        database.TABLE_RECORD_MAP_KEY <- Tags.OilType,
                        database.TABLE_RECORD_MAP_VALUE <- String.init(format: "%@", self.formValues()[Tags.OilType]! as! CVarArg),
                        database.TABLE_RECORD_MAP_TYPE <- "String"
                    ))
                    
                    try database.db.run(database.TABLE_RECORD_MAP.insert(
                        database.TABLE_RECORD_MAP_ID <- rowid,
                        database.TABLE_RECORD_MAP_KEY <- Tags.UnitPrice,
                        database.TABLE_RECORD_MAP_VALUE <- String.init(format: "%@", self.formValues()[Tags.UnitPrice]! as! CVarArg),
                        database.TABLE_RECORD_MAP_TYPE <- "Double"
                    ))
                    
                    try database.db.run(database.TABLE_RECORD_MAP.insert(
                        database.TABLE_RECORD_MAP_ID <- rowid,
                        database.TABLE_RECORD_MAP_KEY <- Tags.OilQuantity,
                        database.TABLE_RECORD_MAP_VALUE <- String.init(format: "%@", self.formValues()[Tags.OilQuantity]! as! CVarArg),
                        database.TABLE_RECORD_MAP_TYPE <- "Double"
                    ))
                }
            }
            self.initializeForm()
        } catch {
            print(error)
            message = "Error: \(error)"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
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
    
        row = XLFormRowDescriptor(tag: Tags.CostType, rowType: XLFormRowDescriptorTypeSelectorActionSheet, title: "Cost type")
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
        
        row = XLFormRowDescriptor(tag: Tags.OilType, rowType: XLFormRowDescriptorTypeSelectorActionSheet, title: "Oil type")
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
            let UnitPrice = self.form.formRow(withTag: Tags.UnitPrice)!;
            let Money = self.form.formRow(withTag: Tags.Money)!;
            let OilQuantity = self.form.formRow(withTag: Tags.OilQuantity)!;
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
