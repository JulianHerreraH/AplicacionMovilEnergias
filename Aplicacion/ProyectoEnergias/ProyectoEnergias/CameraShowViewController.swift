//
//  CameraShowViewController.swift
//  ProyectoEnergias
//
//  Created by Ali Bryan Villegas Zavala on 3/20/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit


class CameraShowViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    @IBOutlet weak var addRecibo: UIButton!
    @IBOutlet weak var SeleccionarRecibo: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        addRecibo.layer.cornerRadius = 5
        SeleccionarRecibo.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }
    


    @IBAction func LoadPhoto(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFill
            imageView.image = chosenImage
            self.dismiss(animated: true, completion: nil)

        } else{
            print("Something went wrong")
        }
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
