//
//  EnergyDetailViewController.swift
//  ProyectoEnergias
//
//  Created by Ali Bryan Villegas Zavala on 3/16/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit
import Foundation

class DeviceInfoViewController: UIViewController {
    var receivedTitle = ""
    var dataUrlString = "http://martinmolina.com.mx/201911/data/ProyectoEnergiasRenovables/appliancesDevices.json"
    var receivedId = ""
    var dataObj:[Any]?

    @IBOutlet weak var DetailTitle: UILabel!
    
    
    @IBOutlet weak var EnergyDefinitionTextView: UITextView!
    
    @IBOutlet weak var EnergyImage1: UIImageView!
    
    @IBOutlet weak var EnergyFact1: UITextView!
    @IBOutlet weak var EnergyImageText: UILabel!
    var deviceURL = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataURL = URL(string: dataUrlString)
        let data = try? Data(contentsOf: dataURL!)
        dataObj = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [AnyObject]
        var a:Int? = Int(receivedId)
        a = a!
        print("FASDFAS")
        print(dataObj)
        let dataD = dataObj?[a!] as! [String:Any]
        print(dataD)
        print(a!)
        print(receivedId)
        let energyData = dataD[receivedId] as! [String:Any]
        
        let statTitle = energyData["DeviceName"] as! String
        
        let energyFact1Text = energyData["DeviceFact"] as! String
        
        let imageURL1 = energyData["comparativeImage"] as! String
        var recommendationsList = ""
        let energyRecommendations = energyData["adviceList"] as! [String]
        for x in energyRecommendations {
            recommendationsList += "-"
            recommendationsList += x
            recommendationsList += "\n\n"
        }
        deviceURL = "https://www.bbc.com/mundo/noticias/2016/04/160426_tecnologia_cuanto_consumen_aparatos_en_bombillos_electricidad_yv"
        DetailTitle.text = statTitle
        EnergyDefinitionTextView.isEditable = false
        EnergyDefinitionTextView.isScrollEnabled = false
        EnergyFact1.isEditable = false
        EnergyFact1.isScrollEnabled = false
        
        
        //EnergyDefinitionTextView.text = energyDef
        EnergyDefinitionTextView.text = energyFact1Text
        EnergyFact1.text = recommendationsList
        EnergyImageText.text = (energyData["imageFoot"] as! String)
        EnergyImage1.imageFromURL(urlString: imageURL1)
        
        
        // Do any additional setup after loading the view.
    }
    
    func JSONParseArray(_ string: String) -> [AnyObject]{
        if let data = string.data(using: String.Encoding.utf8){
            
            do{
                
                if let array = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)  as? [AnyObject] {
                    return array
                }
            }catch{
                
                print("error")
                //handle errors here
                
            }
        }
        return [AnyObject]()
    }
    
    @IBAction func openDeviceURL(_ sender: Any) {
        if deviceURL != ""{
            UIApplication.shared.open(URL(string: deviceURL)!)
        }
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let next = segue.destination as! MapViewController
        next.receivedAppliance = self.DetailTitle.text ?? "Electrodomésticos"
        let backItem = UIBarButtonItem()
        backItem.title = DetailTitle.text
        navigationItem.backBarButtonItem = backItem
    }
    
}
