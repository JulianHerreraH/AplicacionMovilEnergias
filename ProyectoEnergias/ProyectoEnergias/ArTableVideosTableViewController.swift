//
//  ArTableVideosTableViewController.swift
//  EcoBook
//
//  Created by Ali Bryan Villegas Zavala on 4/8/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//


import UIKit

class ArTableVideosTableViewController: UITableViewController, UISearchResultsUpdating{
    var SelectedURL = ""
    var SelectedIs360 = ""
    let dataStringURL = "http://martinmolina.com.mx/201911/data/ProyectoEnergiasRenovables/ARvideos.json"
    var dataObj: [Any]?
    var receivedId = -1
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
                titleText +=  objectData["Title"] as! String
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
        
        filteredData = dataObj!
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        self.definesPresentationContext = true //asociar barra de busqueda con la tabla
        tableView.tableHeaderView = searchController.searchBar
        
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
       
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ARMainCell", for: indexPath) as! ARTableCellTableViewCell
        // Configure the cell...
        //cell.textLabel?.text = dinos[indexPath.row]
        let objectData = filteredData[indexPath.row] as! [String:Any]
        //let sectionName:String = objectData["ARMainSectionName"] as! String
        var titleText = ""
        //titleText +=  objectData["Panel"] as! String
        titleText += objectData["Title"] as! String
        cell.cellTitleText.text = titleText
        
        var dataText = objectData["Description"] as! String
        cell.cellDataLabel.text = dataText
        var imageURL = objectData["Thumbnail"] as! String
        cell.cellImage.imageFromURL(urlString: imageURL)
        
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
        let next = segue.destination as! ARVIDEOSViewController
        let indice = self.tableView.indexPathForSelectedRow?.row
        let objectData = dataObj?[indice!] as! [String:Any]
        let url:String = objectData["VideoURL"] as! String
        let is360Video:String = objectData["is360"] as! String
        next.is360 = is360Video
        next.receivedURL = url
        let backItem = UIBarButtonItem()
        backItem.title = "Videos"
        navigationItem.backBarButtonItem = backItem
     // Pass the selected object to the new view controller.
     }
    
}
