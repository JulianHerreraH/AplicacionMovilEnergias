//
//  MainConsumptionViewController.swift
//  ProyectoEnergias
//
//  Created by Ali Bryan Villegas Zavala on 3/15/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit

class MainConsumptionViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var newBillButton: UIButton!
    
    @IBOutlet weak var misEstadisticasButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newBillButton.layer.cornerRadius = 5
        newBillButton.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.1)
   newBillButton.layer.borderWidth = 1
   newBillButton.layer.borderColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.1).cgColor
        misEstadisticasButton.layer.borderWidth = 1
        misEstadisticasButton.layer.borderColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.2).cgColor
        misEstadisticasButton.layer.cornerRadius = 5
   
    misEstadisticasButton.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.1)
        // Do any additional setup after loading the view.
    }

    @IBAction func newBillButtonAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion:nil)
        }
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
