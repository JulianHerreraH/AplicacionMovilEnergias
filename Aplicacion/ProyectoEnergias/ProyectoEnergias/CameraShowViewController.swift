//
//  CameraShowViewController.swift
//  ProyectoEnergias
//
//  Created by Ali Bryan Villegas Zavala on 3/20/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit

import TesseractOCR

class CameraShowViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, G8TesseractDelegate {

    let tesseract:G8Tesseract = G8Tesseract(language: "spa")
    @IBOutlet weak var addRecibo: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var SeleccionarRecibo: UIButton!
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
    @IBAction func pickPhoto(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[.originalImage] as? UIImage {
            self.dismiss(animated: true, completion: nil)
            var img = chosenImage
            let context = CIContext(options: nil)
            let currentFilter = CIFilter(name: "CIPhotoEffectNoir")
            currentFilter!.setValue(CIImage(image: img), forKey: kCIInputImageKey)
            let output = currentFilter!.outputImage
            let cgimg = context.createCGImage(output!,from: output!.extent)
            let processedImage = UIImage(cgImage: cgimg!)
            img  = processedImage
            let glContext = EAGLContext(api: .openGLES2)!
            let ciContext = CIContext(eaglContext: glContext, options: [CIContextOption.outputColorSpace : NSNull()])
            let filter = CIFilter(name: "CIPhotoEffectMono")
            filter!.setValue(CIImage(image: img), forKey: "inputImage")
            let outputImage = filter!.outputImage
            let cgimg2 = ciContext.createCGImage(outputImage!, from: (outputImage?.extent)!)
            let processedImage2 = UIImage(cgImage: cgimg2!)
            img = processedImage2
            /*
            let contextNoise = CIContext(options: nil)
            let currentFilterNoise = CIFilter(name: "CIExposureAdjust")
            currentFilterNoise!.setValue(CIImage(image: img), forKey: kCIInputImageKey)
            let outputNoise = currentFilterNoise!.outputImage
            let cgimgNoise = contextNoise.createCGImage(outputNoise!,from: outputNoise!.extent)
            let processedImageNoise = UIImage(cgImage: cgimgNoise!)
            img  = processedImageNoise
             */
            /*
            var filterBright = CIFilter(name: "CIColorControls");
            filterBright!.setValue(CIImage(image: img), forKey: "inputBrightness")
            var image = img
            var rawimgData = CIImage(image: image)
            filterBright!.setValue(rawimgData, forKey: "inputImage")
            var outpuImage = filterBright!.value(forKey: "outputImage")
            img = outpuImage as! UIImage
             */
            /*let maxDimension: CGFloat = 640
            var scaledSize = CGSize(width: maxDimension, height: maxDimension)
            var scaleFactor: CGFloat
            
            if img.size.width > img.size.height {
                scaleFactor = img.size.height / img.size.width
                scaledSize.width = maxDimension
                scaledSize.height = scaledSize.width * scaleFactor
            } else {
                scaleFactor = img.size.width / img.size.height
                scaledSize.height = maxDimension
                scaledSize.width = scaledSize.height * scaleFactor
            }
            
            UIGraphicsBeginImageContext(scaledSize)
            img.draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            img = scaledImage! */
            tesseract.pageSegmentationMode = .singleBlock
            tesseract.image = imageView.image
            imageView.image = img
            tesseract.image = img
            tesseract.recognize()
            print("XXXXXX")
            print("The text is")
            print(tesseract.recognizedText!)
        } else{
            print("Something went wrong")
        }
    }
    func shouldCancelImageRecognition(for tesseract: G8Tesseract!) -> Bool {
        return false
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Regresar"
        navigationItem.backBarButtonItem = backItem
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
