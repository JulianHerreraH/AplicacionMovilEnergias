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
    var comingFrom = ""
    let defaults = UserDefaults.standard
    let tarifas = ["1", "1A", "1B", "1C", "1D", "1E", "1F", "DAC"];
    let years = ["2019", "2018", "2017", "2016","2015","2014","2013","2012","2011","2010","2009","2008"];
    let meses = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"]
    var hasReceivedData:Bool = false
    var receivedBillData:[String:String] = ["CostoTotal": "?",
                                            "PeriodoInicial": "?",
                                            "PeriodoFinal": "?",
                                            "Tarifa": "?",
                                            "ConsumoTotal" : "?" , "añoInicial": "?", "añoFinal": "?"]
    @IBOutlet weak var addReceiptButton: UIButton!
    @IBOutlet weak var periodoFinal: UIPickerView!
    @IBOutlet weak var tarifaPicker: UIPickerView!
    
    @IBOutlet weak var yearFinal: UIPickerView!
    @IBOutlet weak var yearInitial: UIPickerView!
    @IBOutlet weak var periodoInicial: UIPickerView!
    
    
    @IBOutlet weak var tarifaTextField: UITextField!
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        addReceiptButton.isEnabled = false
        tarifaPicker.delegate   = self
        tarifaPicker.dataSource = self
        yearInitial.delegate = self
        yearInitial.dataSource = self
        yearFinal.delegate = self
        yearFinal.dataSource = self
        periodoInicial.delegate = self
        periodoInicial.dataSource = self
        periodoFinal.delegate = self
        periodoFinal.dataSource = self
        kwTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        totalCostTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        if( hasReceivedData){
            let alert = UIAlertController(title: "Importante!", message: "Revisa que la información extraída sea correcta o complétala de ser necesario", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default,handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
            self.present(alert,animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            }
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
            else{
                receivedBillData["PeriodoInicial"] = "Ene"
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
            else{
                receivedBillData["PeriodoFinal"] = "Mar"
            }
            if (receivedBillData["añoInicial"] != "?"){
                var indx = 0
                for year in years{
                    let scannedYear = receivedBillData["añoInicial"] as! String
                    if year == scannedYear.uppercased() {
                        break;
                    }
                    indx = indx + 1
                }
                yearInitial.selectRow(indx, inComponent: 0, animated: true)
                yearInitial.reloadAllComponents()
            }
            else{
                receivedBillData["añoInicial"] = "2019"
            }
            if (receivedBillData["añoFinal"] != "?"){
                var indx = 0
                for year in years{
                    let scannedYear = receivedBillData["añoFinal"] as! String
                    if year == scannedYear.uppercased() {
                        break;
                    }
                    indx = indx + 1
                }
                yearFinal.selectRow(indx, inComponent: 0, animated: true)
                yearFinal.reloadAllComponents()
            }
            else{
                receivedBillData["añoFinal"] = "2019"
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
            else{
                receivedBillData["Tarifa"] = "1"

            }
        }
        else{
            receivedBillData["Tarifa"] = "1"
            receivedBillData["añoInicial"] = "2019"
            receivedBillData["añoFinal"] = "2019"
            receivedBillData["PeriodoInicial"] = "Ene"
            receivedBillData["PeriodoFinal"] = "Mar"
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
        self.totalCostTextField.inputAccessoryView = toolbar
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
        var fin = Int(receivedBillData["añoFinal"]!) ?? 2000
        var ini = Int(receivedBillData["añoInicial"]!) ?? 2010
        if(fin < ini){
            let alert = UIAlertController(title: "Cuidado!", message: "Período Final no puede ser menor o igual al inicial", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default,handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
            self.present(alert,animated: true, completion: nil)
        }
        else{
            saveCFEData()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == totalCostTextField{
            if(totalCostTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""){
                receivedBillData["CostoTotal"] = totalCostTextField.text
                
            }
        }
        else if textField == kwTextField{
            if(kwTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""){
                receivedBillData["ConsumoTotal"] = kwTextField.text
                
            }
        }
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
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == tarifaPicker {
            receivedBillData["Tarifa"] = tarifas[row]
        }
        else if pickerView == yearFinal{
            receivedBillData["añoFinal"] = years[row]
        }
        else if pickerView == yearInitial{
            receivedBillData["añoInicial"] = years[row]
        }
        else if pickerView == periodoInicial{
            receivedBillData["PeriodoInicial"] = meses[row]
        }
        else if pickerView == periodoFinal{
            receivedBillData["PeriodoFinal"] = meses[row]
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
        else if pickerView == yearInitial || pickerView == yearFinal {
            return years[row]
        }
        return self.tarifas[row];
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == tarifaPicker {
            receivedBillData["Tarifa"] = tarifas[row]
        }
        else if pickerView == yearFinal{
            receivedBillData["añoFinal"] = years[row]
        }
        else if pickerView == yearInitial{
            receivedBillData["añoInicial"] = years[row]
        }
        else if pickerView == periodoInicial{
            receivedBillData["PeriodoInicial"] = meses[row]
        }
        else if pickerView == periodoFinal{
            receivedBillData["PeriodoFinal"] = meses[row]
        }
        
    }
    
    
    func saveCFEData() {
        defaults.set(true, forKey: "hasEnergyBill")
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: receivedBillData, options: .prettyPrinted)
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // here "decoded" is of type `Any`, decoded from JSON data
            
            // you can now cast it with the right type
            if let dictFromJSON = decoded as? [String:String] {
                print("JSON")
                print(dictFromJSON)// use dictFromJSON
            }
            // here "jsonData" is the dictionary encoded in JSON data
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Regresar"
        navigationItem.backBarButtonItem = backItem
        //navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    override func viewWillAppear(_ animated: Bool){
        /*
         var parentVC = self.children
         if parentVC.count > 0{
         print("APRENT")
         let pp = parentVC[0]
         if pp is StatisticsViewController {
         navigationController?.popViewController(animated: false)
         }
         }
         */
    }
    override func viewWillDisappear(_ animated: Bool){
        /*
         let viewControllers: [UIViewController] = self.navigationController!.viewControllers
         if (self.isMovingFromParent) {
         for aViewController in viewControllers {
         if(aViewController is SelectTypeOfReceiptAdViewController){
         self.navigationController!.popToViewController(aViewController, animated: true);
         }
         }
         // Do your stuff here
         }
         */
    }
    
}
