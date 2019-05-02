//
//  ProfileSettingsTableViewController.swift
//  EcoBook
//
//  Created by Ali Bryan Villegas Zavala on 3/25/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//


import UIKit
import FirebaseAuth
import Firebase
class ProfileSettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var eraseDataButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Your action here
        print(indexPath.row)
        if indexPath.row == 1 {
            confirmDataErase()
        }
        else if indexPath.row == 2 {
            confirmLogout()
        }
    }
   
    func confirmLogout(){
        showSpinner(onView: self.view)
        try! Auth.auth().signOut()

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.removeSpinner()
            self.performSegue(withIdentifier: "logoutSegue", sender: self)
        }
        

    }
    func confirmDataErase(){
        let alert = UIAlertController(title: "Borrar Datos", message: "Confirmas borrar la información agregada a esta aplicación, importante: Esta opción no borra tu cuenta, únicamente los datos que se han guardado en ella", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: {_ in
            // erases firebase Data
            let ref:DatabaseReference = Database.database().reference()
            ref.child("usuarios").child(Auth.auth().currentUser!.uid).child("Recibos").removeValue()
            // alert to indicate it has been erased
            
            let alert = UIAlertController(title: "Éxito", message: "Tus datos personales han sido eliminados, ahora no tienes ningún recibo guardado. Cerraremos tu sesión para refrescar la app", preferredStyle: .alert);
        
            alert.addAction(UIAlertAction(title: "ok", style: .cancel,handler: {(action) in
                self.confirmLogout()
                alert.dismiss(animated: true, completion: nil)}))
            self.present(alert,animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel,handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert,animated: true, completion: nil)
    }
    // MARK: - Table view data source
    /*
     override func numberOfSections(in tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     return 1
     }
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     // #warning Incomplete implementation, return the number of rows
     return 3
     }
     
     
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
     
     cell.textLabel?.text = settings[indexPath.row]
     
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
     */
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = "Perfil"
        navigationItem.backBarButtonItem = backItem
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
}
