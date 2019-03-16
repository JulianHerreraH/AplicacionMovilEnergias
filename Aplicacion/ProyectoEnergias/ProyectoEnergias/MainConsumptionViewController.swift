//
//  MainConsumptionViewController.swift
//  ProyectoEnergias
//
//  Created by Ali Bryan Villegas Zavala on 3/15/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit

class MainConsumptionViewController: UIViewController {

    @IBOutlet weak var newBillButton: UIButton!
    
    @IBOutlet weak var misEstadisticasButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newBillButton.layer.cornerRadius = 5
        newBillButton.backgroundColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
    misEstadisticasButton.layer.cornerRadius = 5
    misEstadisticasButton.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func InformationButtonConsumption(_ sender: UITapGestureRecognizer) {
        
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
