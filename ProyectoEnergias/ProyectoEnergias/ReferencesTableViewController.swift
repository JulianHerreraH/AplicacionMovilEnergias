//
//  LearnTableViewController.swift
//  ProyectoEnergias
//
//  Created by cdt307 on 3/6/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit


class ReferencesTableViewController: UITableViewController,UISearchResultsUpdating {
    
    
    let dataStringURL = "http://martinmolina.com.mx/201911/data/ProyectoEnergiasRenovables/References.json"
    var dataObj: [Any]?
    var urls:[String] = ["","","","","","","","","","","","","","","","","",""]
    var filteredData = [Any]()
    let searchController = UISearchController(searchResultsController: nil)
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text! == "" {
            filteredData = dataObj!
        }
        else{
            filteredData = dataObj!.filter{
                let objectData=$0 as! [String:Any]
                let s:String = objectData["Reference"] as! String
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
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = 100
        
        let dataURL = URL(string:dataStringURL)
        let data = try? Data(contentsOf: dataURL!)
        
        dataObj = try!JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)  as? [AnyObject]
        
        /*dinosFiltrados = dinosObj!
         searchController.searchResultsUpdater = self
         searchController.dimsBackgroundDuringPresentation = false
         searchController.hidesNavigationBarDuringPresentation = false
         self.definesPresentationContext = true //asociar barra de busqueda con la tabla
         tableView.tableHeaderView = searchController.searchBar*/
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataObj!.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "learnMainCell", for: indexPath)
        
        // Configure the cell...
        //cell.textLabel?.text = dinos[indexPath.row]
        let objectData = dataObj![indexPath.row] as! [String:Any]
        var sectionName:String = "- "
        sectionName += objectData["Reference"] as! String
        print("indexrow \(indexPath.row)")

        print("URLS \(urls)")
        urls[indexPath.row] = objectData["URL"] as! String
        
        //cell.textLabel?.text = sectionName
        //cell.imageView?.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        cell.textLabel!.text = sectionName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedURL = urls[indexPath.row]
        if selectedURL != "" {
            UIApplication.shared.open(URL(string: selectedURL)!)
        }
        
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
        let backItem = UIBarButtonItem()
        backItem.title = "Referencias"
        navigationItem.backBarButtonItem = backItem
        // Pass the selected object to the new view controller.
    }
    
}
