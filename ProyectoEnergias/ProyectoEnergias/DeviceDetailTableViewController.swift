//
//  ARMainTableViewController.swift
//  ProyectoEnergias
//
//  Created by cdt307 on 3/6/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit

class DeviceDetailTableViewController: UITableViewController, UISearchResultsUpdating{
    
    let dataStringURL = "http://martinmolina.com.mx/201911/data/ProyectoEnergiasRenovables/DevicesTitles.json"
    var dataObj: [Any]?
    var receivedId = -1
    var currentSection = ""
    @IBOutlet weak var cellImage: UIImageView!
    
    @IBOutlet weak var cellTitle: UIImageView!
    
    var filteredData = [Any]()
    let searchController = UISearchController(searchResultsController: nil)
    
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text! == "" {
            filteredData = dataObj!
        }
        else{
            filteredData = dataObj!.filter{
                let objectData=$0 as! [String:Any]
                
                var titleText = objectData["DevicesTitle"] as! String
                return(titleText.lowercased().contains(searchController.searchBar.text!.lowercased()))
            }
        }
        self.tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected Section 0")
        
        if indexPath.section == 0
        {
            performSegue(withIdentifier: "goToDevicesGraph", sender: self)
        }
        else {
            performSegue(withIdentifier: "showDeviceSegue", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ****Usando string, dinosObj = JSONParseArray(dinosJSON)***
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        var dataURL = URL(string:dataStringURL)
        let data = try? Data(contentsOf: dataURL!)
        dataObj = try!JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)  as? [AnyObject]
        
        filteredData = dataObj!
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        self.definesPresentationContext = true //asociar barra de busqueda con la tabla
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return filteredData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }
        return filteredData.count - 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let objectData = filteredData[section] as! [String:Any]
        return (objectData["DevicesTitle"] as! String)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.darkGray
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DevicesCell", for: indexPath) as! ARTableCellTableViewCell
        // Configure the cell...
        //cell.textLabel?.text = dinos[indexPath.row]
        let objectData = filteredData[indexPath.section] as! [String:Any]
        //let sectionName:String = objectData["ARMainSectionName"] as! String
        let devicesPerCategory = objectData["Devices"] as! [Dictionary<String,AnyObject>]
        var titleText = devicesPerCategory
        print(devicesPerCategory)
        var firstTitle = titleText[indexPath.row]
        
        cell.cellTitleText.text = (firstTitle["name"] as! String)
        let imageURL = (firstTitle["imageURL"] as! String)
        cell.cellImage.imageFromURL(urlString: imageURL)
        /*  var dataText = objectData["Lumens"] as! String
         dataText += ", "
         dataText += objectData["ColorTemp"] as! String
         dataText += ", Vida: "
         dataText += objectData["Lifetime"] as! String
         
         //cell.cellDataLabel.text = dataText
         var imageURL = objectData["Image"] as! String
         cell.cellImage.imageFromURL(urlString: imageURL)
         */
        //cell.textLabel?.text = sectionName
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     let siguiente = segue.destination as! DetalleDinoViewController
     let indice = self.tableView.indexPathForSelectedRow?.row
     let objetoDino = dinosObj[indice!] as! [String:Any]
     let dino:String = objetoDino["dino"] as! String
     let dieta:String = objetoDino["dieta"] as! String
     siguiente.dinoRecibido = dino
     siguiente.dietaRecibida = dieta
     // Pass the selected object to the new view controller.
     }*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "goToDevicesGraph") {
            
        }
        else {
            if(self.tableView.indexPathForSelectedRow?.section != 0){
                let siguiente = segue.destination as! DeviceInfoViewController
                
                var objectData = filteredData[0] as! [String:Any]
                
                if(self.tableView.indexPathForSelectedRow?.section == 1){
                    objectData = filteredData[1] as! [String:Any]
                }
                else if(self.tableView.indexPathForSelectedRow?.section == 2){
                    objectData = filteredData[2] as! [String:Any]
                    
                }
                else if(self.tableView.indexPathForSelectedRow?.section == 3){
                    objectData = filteredData[3] as! [String:Any]
                    
                }
                let devicesPerCategory = objectData["Devices"] as! [Dictionary<String,AnyObject>]
                var titleText = devicesPerCategory
                var firstTitle = titleText[(self.tableView.indexPathForSelectedRow?.row)!]
                
                let indice = (firstTitle["_id"] as! String)
                siguiente.receivedId = indice
            }
            
        }
        
        let backItem = UIBarButtonItem()
        backItem.title = "Dispositivos"
        
        navigationItem.backBarButtonItem = backItem
        // Pass the selected object to the new view controller.
    }
    
}
