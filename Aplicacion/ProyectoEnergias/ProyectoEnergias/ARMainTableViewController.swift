//
//  ARMainTableViewController.swift
//  ProyectoEnergias
//
//  Created by cdt307 on 3/6/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit

class ARMainTableViewController: UITableViewController, UISearchResultsUpdating {

    let dataStringURL = "https://api.jsonbin.io/b/5c8042022e4731596f182b3c"
    var dataObj: [Any]?
    
    var filteredData = [Any]()
    let searchController = UISearchController(searchResultsController: nil)
    
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text! == "" {
            filteredData = dataObj!
        }
        else{
            filteredData = dataObj!.filter{
                let objectData=$0 as! [String:Any]
                let s:String = objectData["ARMainSectionName"] as! String
                return(s.lowercased().contains(searchController.searchBar.text!.lowercased()))
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
        let dataURL = URL(string:dataStringURL)
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ARMainCell", for: indexPath)
        
        // Configure the cell...
        //cell.textLabel?.text = dinos[indexPath.row]
       let objectData = filteredData[indexPath.row] as! [String:Any]
        let sectionName:String = objectData["ARMainSectionName"] as! String
        
        cell.textLabel?.text = sectionName
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

}
