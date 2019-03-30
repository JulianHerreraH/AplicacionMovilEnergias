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
    let defaults = UserDefaults.standard
    let tarifas = ["1", "1A", "1B", "1C", "1D", "1E", "1F"];
    let meses = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
    
    @IBOutlet weak var addReceiptButton: UIButton!
    @IBOutlet weak var periodoFinal: UIPickerView!
    @IBOutlet weak var tarifaPicker: UIPickerView!
    
    @IBOutlet weak var periodoInicial: UIPickerView!
    
    
    @IBOutlet weak var tarifaTextField: UITextField!
    
    
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        kwTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        addReceiptButton.isEnabled = false
        tarifaPicker.delegate   = self
        tarifaPicker.dataSource = self
        periodoInicial.delegate = self
        periodoInicial.dataSource = self
        periodoFinal.delegate = self
        periodoFinal.dataSource = self
        //init toolbar
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector(doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        //setting toolbar as inputAccessoryView
        self.kwTextField.inputAccessoryView = toolbar
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
        if kwTextField.text != "" {
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
