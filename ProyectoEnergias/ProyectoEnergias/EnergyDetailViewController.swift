//
//  EnergyDetailViewController.swift
//  ProyectoEnergias
//
//  Created by Ali Bryan Villegas Zavala on 3/16/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit
import Foundation
extension UIImageView {
    public func imageFromURL(urlString: String) {
        
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        activityIndicator.startAnimating()
        if self.image == nil{
            self.addSubview(activityIndicator)
        }
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                activityIndicator.removeFromSuperview()
                self.image = image
            })
            
        }).resume()
    }
}
class EnergyDetailViewController: UIViewController {
    var receivedTitle = ""
    var dataUrlString = "http://martinmolina.com.mx/201911/data/ProyectoEnergiasRenovables/EnergyInformation.json"
    var receivedEnergyId = -1
    var dataObj:[Any]?
    @IBOutlet weak var DetailTitle: UILabel!
    
    
    @IBOutlet weak var EnergyDefinitionTextView: UITextView!
    
    @IBOutlet weak var EnergyImage1: UIImageView!
    
    @IBOutlet weak var EnergyFact1: UITextView!
    @IBOutlet weak var EnergyImageText: UILabel!
    
    @IBOutlet weak var EnergyImage2: UIImageView!
    
    @IBOutlet weak var EnergyFact2: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DetailTitle.text = receivedTitle
        let dataURL = URL(string: dataUrlString)
        let data = try? Data(contentsOf: dataURL!)
        dataObj = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [AnyObject]
        let dataObject = dataObj?[receivedEnergyId] as! [String:Any]
        
        let energyData = dataObject[receivedTitle] as! Dictionary<String,AnyObject>
        let energyDef = energyData["Energy Definition"] as! String
        let energyFact1Text = energyData["EnergyFact1"] as! String
        
        let energyFact2Text = energyData["EnergyFact2"] as! String
        let imageURL1 = energyData["EnergyImage1"] as! String
        let imageURL2 = energyData["EnergyImage2"] as! String

        EnergyDefinitionTextView.isEditable = false
        EnergyDefinitionTextView.isScrollEnabled = false
        EnergyFact1.isEditable = false
        EnergyFact1.isScrollEnabled = false
        EnergyFact2.isEditable = false
        EnergyFact2.isScrollEnabled = false
        
        EnergyDefinitionTextView.text = energyDef
        EnergyFact1.text = energyFact1Text
        EnergyFact2.text = energyFact2Text
        EnergyImageText.text = (energyData["EnergyImageNote"] as! String)
        EnergyImage1.imageFromURL(urlString: imageURL1)

        EnergyImage2.imageFromURL(urlString: imageURL2)

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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
