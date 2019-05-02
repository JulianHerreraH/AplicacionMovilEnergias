//
//  StatisticsViewController.swift
//  ProyectoEnergias
//
//  Created by Ali Bryan Villegas Zavala on 3/16/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit
import Firebase

class StatisticsViewController: UIViewController {
    @IBOutlet weak var statisticsFirstLabel: UILabel!
    @IBOutlet weak var consumptionPeriodButton: UIButton!
    @IBOutlet weak var regionButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        showSpinner(onView: self.view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // Change `2.0` to the desired number of seconds.
            self.checkIfUserHasData()
            // Code you want to be delayed
        }
        
    }
    
    @objc func goToAddBill(){
        print("ENTERED")
        
        performSegue(withIdentifier: "goToBillSegue", sender: statisticsFirstLabel)
        
    }
 
    func checkIfUserHasData(){
        var hasAtLeastOneEnergyBill = true
        var ref:DatabaseReference = Database.database().reference()
        ref.child("usuarios").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            print("ENTERED")
            hasAtLeastOneEnergyBill = snapshot.hasChild("Recibos")
            print("HAS CHILD", hasAtLeastOneEnergyBill)
            if snapshot.hasChild("Recibos") {
                self.displayStatistics()
                self.removeSpinner()
            }
            else{
                self.statisticsFirstLabel.text  = "No has agregado ningún recibo de luz, da click a este mensaje para agregar un recibo"
                self.statisticsFirstLabel.textColor = UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
                self.regionButton.isEnabled = false
                self.consumptionPeriodButton.isEnabled = false
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.goToAddBill))
                gestureRecognizer.numberOfTapsRequired = 1
                // Do any additional setup after loading the view.
                self.statisticsFirstLabel.addGestureRecognizer(gestureRecognizer)
                self.removeSpinner()
            }
        }) { (error) in
            let alert = UIAlertController(title: "alerta", message: error.localizedDescription, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            print("ERRORFOUND")
            print(error.localizedDescription)
            self.validateFoundData()
            self.removeSpinner()
        }
    }
    
    /*
    func checkIfEnergyBill() -> Bool{
        var hasAtLeastOneEnergyBill = true
        var ref:DatabaseReference = Database.database().reference()
        ref.child("usuarios").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            hasAtLeastOneEnergyBill = snapshot.hasChild("Recibos")
            if self.validateFoundData() {
                
            }
            else {
                
            }
            }) { (error) in
            let alert = UIAlertController(title: "alerta", message: error.localizedDescription, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            print("ERRORFOUND")
            print(error.localizedDescription)
            self.validateFoundData()
        }
        print("SECOND HAS")
        print(hasAtLeastOneEnergyBill)
        if hasAtLeastOneEnergyBill {
            displayStatistics()
            return true
        }
        else{
            self.statisticsFirstLabel.text  = "No has agregado ningún recibo de luz, da click a este mensaje para agregar un recibo"
                self.statisticsFirstLabel.textColor = UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
            regionButton.isEnabled = false
            consumptionPeriodButton.isEnabled = false
            return false
        }
    }
    */
    func validateFoundData(){
        
    }
    func displayStatistics(){
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Mis Estadísticas"
        navigationItem.backBarButtonItem = backItem
    }
    
    override func viewWillDisappear(_ animated: Bool){
        /*
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        if (self.isMovingFromParent) {
            for aViewController in viewControllers {
                if(aViewController is SelectTypeOfReceiptAdViewController){
                    self.navigationController!.popToViewController(aViewController, animated: true);
                }
            }
            // Do your stuff here
        }
 */
    }
    

}
