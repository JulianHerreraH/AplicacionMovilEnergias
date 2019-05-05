//
//  ARMainTableViewController.swift
//  ProyectoEnergias
//
//  Created by cdt307 on 3/6/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit

class StatisticsLocalTableViewController: UITableViewController, UISearchResultsUpdating{
    
    let dataStringURL = "http://martinmolina.com.mx/201911/data/ProyectoEnergiasRenovables/StatsTitleMexico.json"
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
                var titleText = ""
                
                if(filteredData.count > 0){
                    let objectData = filteredData[0] as! [String:Any]
                    //let sectionName:String = objectData["ARMainSectionName"] as! String
                    let devicesPerCategory = objectData["Statistics"] as! [Dictionary<String,AnyObject>]
                    var counter = 0
                    for x in devicesPerCategory{
                        var firstTitle = devicesPerCategory[counter]
                        var s = (firstTitle["name"] as! String)
                        if(s.lowercased().contains(searchController.searchBar.text!.lowercased())){
                            titleText += s
                            titleText += " "
                        }
                        
                        counter = counter + 1
                        
                    }
                }
                print(titleText)
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
        print(dataObj)
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(filteredData.count > 0){
            let objectData = filteredData[0] as! [String:Any]
            //let sectionName:String = objectData["ARMainSectionName"] as! String
            let devicesPerCategory = objectData["Statistics"] as! [Dictionary<String,AnyObject>]
            return devicesPerCategory.count
        }
        else {
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GlobalStatsCell", for: indexPath) as! ARTableCellTableViewCell
        // Configure the cell...
        //cell.textLabel?.text = dinos[indexPath.row]
        let objectData = filteredData[0] as! [String:Any]
        //let sectionName:String = objectData["ARMainSectionName"] as! String
        let devicesPerCategory = objectData["Statistics"] as! [Dictionary<String,AnyObject>]
        var titleText = devicesPerCategory
        var firstTitle = titleText[indexPath.row]
        cell.cellTitleText.text = (firstTitle["name"] as! String)
        let imageURL = (firstTitle["imageURL"] as! String)
        cell.cellImage.imageFromURL(urlString: imageURL)
        cell.cellTitleText.numberOfLines = 3
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        let siguiente = segue.destination as! StatsDetailsViewController
        let objectData = filteredData[0] as! [String:Any]
        siguiente.clickedSection = "Mexico"
        
        //let sectionName:String = objectData["ARMainSectionName"] as! String
        let devicesPerCategory = objectData["Statistics"] as! [Dictionary<String,AnyObject>]
        var titleText = devicesPerCategory
        var firstTitle = titleText[(self.tableView.indexPathForSelectedRow?.row)!]
        let indice = (firstTitle["_id"] as! String)
        siguiente.receivedId = indice
        let backItem = UIBarButtonItem()
        backItem.title = "Mexico"
        
        navigationItem.backBarButtonItem = backItem
        // Pass the selected object to the new view controller.
    }
}
