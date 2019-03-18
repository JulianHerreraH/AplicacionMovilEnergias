//
//  WelcomeScreenComsumptionViewController.swift
//  ProyectoEnergias
//
//  Created by Ali Bryan Villegas Zavala on 3/15/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit

class WelcomeScreenComsumptionViewController: UIViewController {

    @IBOutlet weak var CalculaTuConsumoLabel: UILabel!
    
    @IBOutlet weak var ImageBulbs: UIImageView!
    
    @IBOutlet weak var ExplanationConsumptionTextView: UITextView!
    
    @IBAction func EmpezarButton(_ sender: UIButton) {
        //performSegue(withIdentifier: "WelcomeConsumptionToConsumption", sender: self)

    }
    
    @IBOutlet weak var EmpezarButtonVar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ExplanationConsumptionTextView.isEditable = false
        EmpezarButtonVar.layer.cornerRadius = 5
            EmpezarButtonVar.clipsToBounds = true
        EmpezarButtonVar.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.1)
        EmpezarButtonVar.layer.borderWidth = 0
            EmpezarButtonVar.layer.cornerRadius = 5
       EmpezarButtonVar.layer.borderColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0).cgColor
        ExplanationConsumptionTextView.isScrollEnabled = false
        //ImageBulbs.layer.cornerRadius =
        //Add Line To Consumo label
        
        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Regresar"
        navigationItem.backBarButtonItem = backItem
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
