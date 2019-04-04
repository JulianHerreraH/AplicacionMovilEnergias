//
//  ManualReceiptViewController.swift
//  EcoBook
//
//  Created by Ali Bryan Villegas Zavala on 3/23/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit

class ManualReceiptViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var kwTextField: UITextField!
    @IBOutlet weak var totalCostTextField: UITextField!
    let defaults = UserDefaults.standard
    let tarifas = ["1", "1A", "1B", "1C", "1D", "1E", "1F", "DAC"];
    let meses = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"]
    var receivedBillData:[String:String] = ["CostoTotal": "?",
                                    "PeriodoInicial": "?",
                                    "PeriodoFinal": "?",
                                    "Tarifa": "?",
                                    "ConsumoTotal" : "?"]
    @IBOutlet weak var addReceiptButton: UIButton!
    @IBOutlet weak var periodoFinal: UIPickerView!
    @IBOutlet weak var tarifaPicker: UIPickerView!
    
    @IBOutlet weak var periodoInicial: UIPickerView!
    
    
    @IBOutlet weak var tarifaTextField: UITextField!
    
    
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        addReceiptButton.isEnabled = false
        tarifaPicker.delegate   = self
        tarifaPicker.dataSource = self
        periodoInicial.delegate = self
        periodoInicial.dataSource = self
        periodoFinal.delegate = self
        periodoFinal.dataSource = self
        kwTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        if (receivedBillData["ConsumoTotal"] != "?"){
            print(receivedBillData["ConsumoTotal"]!)
            kwTextField.text = receivedBillData["ConsumoTotal"]
            kwTextField.reloadInputViews()
        }
        if (receivedBillData["CostoTotal"] != "?"){
            print(receivedBillData["CostoTotal"]!)
            var costo = receivedBillData["CostoTotal"]!.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
            if costo.count > 4 {
                costo = String(costo.prefix(4))
            }
            totalCostTextField.text = costo
            totalCostTextField.reloadInputViews()

        }
        if (receivedBillData["PeriodoInicial"] != "?"){
            var monthIndex = 0
            for period in meses{
                let scannedMonth = receivedBillData["PeriodoInicial"] as! String
                if period.lowercased() == scannedMonth.lowercased() {
                    break;
                }
                monthIndex = monthIndex + 1
            }
            periodoInicial.selectRow(monthIndex, inComponent: 0, animated: true)
            periodoInicial.reloadAllComponents()
        }
        if (receivedBillData["PeriodoFinal"] != "?"){
            var monthIndex = 0
            for period in meses{
                let scannedMonth = receivedBillData["PeriodoFinal"] as! String
                if period.lowercased() == scannedMonth.lowercased() {
                    break;
                }
                monthIndex = monthIndex + 1
            }
            periodoFinal.selectRow(monthIndex, inComponent: 0, animated: true)
            periodoFinal.reloadAllComponents()
        }
        
        if (receivedBillData["Tarifa"] != "?"){
            var tarifaIndex = 0
            for tarifa in tarifas{
                let scannedTarifa = receivedBillData["Tarifa"] as! String
                if tarifa == scannedTarifa.uppercased() {
                    break;
                }
                tarifaIndex = tarifaIndex + 1
            }
            tarifaPicker.selectRow(tarifaIndex, inComponent: 0, animated: true)
            print(tarifas[tarifaIndex])
            tarifaPicker.reloadAllComponents()
        }
        //init toolbar
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector(doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        //setting toolbar as inputAccessoryView
        self.kwTextField.inputAccessoryView = toolbar
        CheckEverythingHasData()
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == periodoInicial || pickerView == periodoFinal{
            return meses.count
        }
        return tarifas.count
    }
    
    @IBAction func addEnergyBill(_ sender: Any) {
        if billDataIsValidated() {
            saveCFEData()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        CheckEverythingHasData()
    }
    func CheckEverythingHasData(){
        if kwTextField.text != "" && totalCostTextField.text != "" {
            addReceiptButton.isEnabled = true
        }
        else {
            addReceiptButton.isEnabled = false
        }
    }
    func billDataIsValidated() -> Bool{
        var valid = true
        return true
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == periodoInicial || pickerView == periodoFinal{
            return meses[row]
        }
        return self.tarifas[row];
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == periodoInicial || pickerView == periodoFinal{
            
        }
        else if pickerView == tarifaPicker{
        }
        
    }
    
    
    func saveCFEData() {
        defaults.set(true, forKey: "hasEnergyBill")
    }
}
