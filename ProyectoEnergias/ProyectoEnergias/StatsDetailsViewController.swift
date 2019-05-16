//
//  EnergyDetailViewController.swift
//  ProyectoEnergias
//
//  Created by Ali Bryan Villegas Zavala on 3/16/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit
import Foundation

class StatsDetailsViewController: UIViewController {
    var receivedTitle = ""
    var dataUrlString = ""
    var receivedId = ""
    var dataObj:[Any]?
    var firstImageURL = ""
    var secondImageURL = ""
    var clickedSection = "http://martinmolina.com.mx/201911/data/ProyectoEnergiasRenovables/statisticsInfoMexico.json"
    @IBOutlet weak var DetailTitle: UILabel!
    
    
    @IBOutlet weak var EnergyDefinitionTextView: UITextView!
    
    @IBOutlet weak var EnergyImage1: UIImageView!
    
    @IBOutlet weak var EnergyFact1: UITextView!
    @IBOutlet weak var EnergyImageText: UILabel!
    
    @IBOutlet weak var EnergyImageText2: UILabel!
    @IBOutlet weak var EnergyImage2: UIImageView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnergyImageText.numberOfLines = 2
        EnergyImageText.lineBreakMode = .byWordWrapping
        EnergyImageText2.lineBreakMode = .byWordWrapping
        EnergyImageText2.numberOfLines = 2
        if(clickedSection == "Mexico"){
            dataUrlString = "http://martinmolina.com.mx/201911/data/ProyectoEnergiasRenovables/statisticsInfoMexico.json"
        }
        if(clickedSection == "Global"){
            dataUrlString = "http://martinmolina.com.mx/201911/data/ProyectoEnergiasRenovables/statisticsInfoGlobal.json"
        }
        let dataURL = URL(string: dataUrlString)
        
        let data = try? Data(contentsOf: dataURL!)
        dataObj = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [AnyObject]
        var a:Int? = Int(receivedId)
        if(clickedSection == "Mexico"){
            a = a! - 4
        }
        if(clickedSection == "Global"){
            a = a! - 1
        }
        
        let dataD = dataObj?[a!] as! [String:Any]
        print(dataD)
        print(receivedId)
        let energyData = dataD[receivedId] as! [String:Any]
        
        
        let statTitle = energyData["StatTitle"] as! String
        
        let energyFact1Text = energyData["StatFact1"] as! String
        
        let energyFact2Text = energyData["StatFact2"] as! String
        let imageURL1 = energyData["StatImage1"] as! String
        let imageURL2 = energyData["StatImage2"] as! String
        firstImageURL = energyData["urlImage1"] as! String
        secondImageURL = energyData["urlImage2"] as! String

       DetailTitle.text = statTitle
        EnergyDefinitionTextView.isEditable = false
        EnergyDefinitionTextView.isScrollEnabled = false
        EnergyFact1.isEditable = false
        EnergyFact1.isScrollEnabled = false
        //EnergyDefinitionTextView.text = energyDef
        EnergyDefinitionTextView.text = energyFact1Text
        EnergyFact1.text = energyFact2Text
        EnergyImageText.text = (energyData["StatImageNote1"] as! String)
        
       EnergyImageText2.text = (energyData["StatImageNote2"] as! String)
        EnergyImage1.imageFromURL(urlString: imageURL1)
        
        EnergyImage2.imageFromURL(urlString: imageURL2)
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func firstImageClicked(_ sender: Any) {
        if firstImageURL != ""  {
            UIApplication.shared.open(URL(string: firstImageURL)!)
        }
    }
    
    @IBAction func sencondImageClicked(_ sender: Any) {
        if secondImageURL != ""  {
            UIApplication.shared.open(URL(string: secondImageURL)!)
        }
        
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
