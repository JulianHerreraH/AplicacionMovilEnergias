//
//  StatisticsViewController.swift
//  ProyectoEnergias
//
//  Created by Ali Bryan Villegas Zavala on 3/16/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    @IBOutlet weak var statisticsFirstLabel: UILabel!
    @IBOutlet weak var consumptionPeriodButton: UIButton!
    @IBOutlet weak var regionButton: UIButton!
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        print(defaults.bool(forKey: "hasEnergyBill"))
        if checkIfEnergyBill() {
            
        }
        else{
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToAddBill))
            gestureRecognizer.numberOfTapsRequired = 1
            // Do any additional setup after loading the view.
            statisticsFirstLabel.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    @objc func goToAddBill(){
        print("ENTERED")
        
        performSegue(withIdentifier: "goToBillSegue", sender: statisticsFirstLabel)
        
    }
 
    
    
    func checkIfEnergyBill() -> Bool{
        let hasAtLeastOneEnergyBill = defaults.bool(forKey: "hasEnergyBill")
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
