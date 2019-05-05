//
//  TestsViewController.swift
//  EcoBook
//
//  Created by Ali Bryan Villegas Zavala on 3/29/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit
import TesseractOCR
class TestsViewController: UIViewController, G8TesseractDelegate{
    let tesseract:G8Tesseract = G8Tesseract(language: "spa")
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tesseract.delegate = self
        print("Running OCR")
        let img = UIImage(named:"feos" )
        tesseract.image = img
        tesseract.recognize()
        print("The text is")
        print(tesseract.recognizedText!)
        // Do any additional setup after loading the view.
    }
    
    func shouldCancelImageRecognition(for tesseract: G8Tesseract!) -> Bool {
        return false
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
