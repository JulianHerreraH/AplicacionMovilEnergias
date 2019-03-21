//
//  HomeLearnViewController.swift
//  ProyectoEnergias
//
//  Created by Ali Bryan Villegas Zavala on 3/16/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit

extension UITextView{
    func setBorderBottom(){
       /* self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width:0.0,height:10)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 0.0*/
        self.layer.cornerRadius = 5
        
    }
}
class HomeLearnViewController: UIViewController {
    
    @IBOutlet weak var DailyFactTextView: UITextView!
    var dataObj:[Any]?
    @IBOutlet weak var GoToRenewableEnergiesButton: UIButton!
    var dataUrlString = "http://martinmolina.com.mx/201911/data/ProyectoEnergiasRenovables/Facts.json"

    override func viewDidLoad() {
        super.viewDidLoad()
       GoToRenewableEnergiesButton.layer.cornerRadius = 3
        //DailyFactTextView.setBorderBottom()
        DailyFactTextView.isEditable = false
        DailyFactTextView.isScrollEnabled = false
        let dataURL = URL(string: dataUrlString)
        let data = try? Data(contentsOf: dataURL!)
        dataObj = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [AnyObject]
        let dataObject = dataObj?[2] as! [String:Any] //DAILY FACT
         let energyFactText = dataObject["Fact"] as! String
        DailyFactTextView.text = energyFactText
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Aprende"
        navigationItem.backBarButtonItem = backItem
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
