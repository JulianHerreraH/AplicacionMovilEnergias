//
//  CameraShowViewController.swift
//  ProyectoEnergias
//
//  Created by Ali Bryan Villegas Zavala on 3/20/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit
import WeScan
import TesseractOCR


class PhotoScanViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, G8TesseractDelegate, ImageScannerControllerDelegate {
    var billData:[String:String] = ["CostoTotal": "?",
                                    "PeriodoInicial": "?",
                                    "PeriodoFinal": "?",
                                    "Tarifa": "?",
                                    "ConsumoTotal" : "?"]
    func saveFoundData(){
        if(recognizedText != ""){
            recognizedText = recognizedText.trimmingCharacters(in: .whitespacesAndNewlines)
            recognizedText = recognizedText.replacingOccurrences(of: " ", with: "")
            recognizedText = recognizedText.lowercased()
            if(recognizedText.contains("$")){
                print("Found $ \n")
                readAndUpdateTotalCost(text: recognizedText)
            }
            if(recognizedText.contains("periodo") || recognizedText.contains("facturado") ){
                print("Found periodo  \n")
                readAndUpdatePeriods(text: recognizedText)
            }
            if(recognizedText.contains("fa:")
                ){
                print("Found tarifa \n")
                readAndUpdateReceiptType(text: recognizedText)
            }
            if(recognizedText.contains("energía") ||
                recognizedText.contains("(ah)")){
                print("Found energia \n")
                readAndUpdateKWH(text: recognizedText)
            }
            let regex = try? NSRegularExpression(pattern: "#[a-z0-9]+", options: .caseInsensitive)
            let results = regex!.matches(in: recognizedText, range: NSRange(recognizedText.startIndex..., in: recognizedText))
            performSegue(withIdentifier: "goToManualReceipt", sender: Any!.self)
        }
    }
    // MARK: - Navigation
    func readAndUpdateTotalCost( text: String){
        var splittedText = text.components(separatedBy: "$")
        var costTxt = splittedText[1].components(separatedBy: ".")
        var onlyCost = costTxt[0]
        print("******")
        print("TOTAL COST")
        billData["CostoTotal"] = onlyCost
        print(billData["CostoTotal"]! )
        print("******")
    }
    
    func readAndUpdateKWH( text: String){
        if(recognizedText.contains("(kwh)")){
            var splittedText = text.components(separatedBy: "(kwh)")
            var costTxt = splittedText[1]
            var counter:Int = 0
            var consumption = ""
            for character in costTxt{
                if(counter >= 10 && counter <= 14){
                    consumption = consumption + String(character)
                    
                }
                if(counter >= 15){
                    break
                }
                counter = counter + 1
            }
            print("******")
            print("Consumo total kWh")
            print("******")
            billData["ConsumoTotal"] = removeNonNumbers(text: consumption)
            print(billData["ConsumoTotal"]! )
            
        }
    }
    
    func removeNonNumbers(text : String) -> String{
        return text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    func readAndUpdateReceiptType( text: String){
        var splittedText = text.components(separatedBy: "fa:")
        var costTxt = splittedText[1]
        var counter:Int = 0
        var tariffType = ""
        for character in costTxt{
            tariffType = tariffType + String(character)
            
            if(counter >= 2){
                break
            }
            counter = counter + 1
        }
        let dat = tariffType
        var maxScore:Double = 0
        var index = 0
        var forloopcounter = 0
        
        for tarifa in tarifas {
            if(dat.levenshteinDistanceScore(to: tarifa) > maxScore){
                maxScore = dat.levenshteinDistanceScore(to: tarifa)
                index = forloopcounter
            }
            forloopcounter = forloopcounter + 1
        }
        
        print("******")
        print("TARIFA")
        print("Closes Match Tarifa")
        print(tarifas[index])
        
        billData["Tarifa"] = tarifas[index]
        print(billData["Tarifa"]!)
        print("******")
        
    }
    func readAndUpdatePeriods( text: String){
        var splittedText = text.components(separatedBy: "facturado:")
        let periods = splittedText[1]
        var bothPeriods = ""
        var counter:Int = 0
        for character in periods{
            if(counter == 15 && String(character) == "9"){
                break
            }
            bothPeriods = bothPeriods + String(character)
            
            if(counter >= 15){
                break
            }
            counter = counter + 1
        }
        var periodsArray = bothPeriods.components(separatedBy: "-")
        var initialPeriod = periodsArray[0]
        if(periodsArray.count > 1){
            var endPeriod = periodsArray[1]
            if(periodsArray[1].count != 0){
                var dat = endPeriod.trimmingCharacters(in: .whitespacesAndNewlines)
                var maxScore:Double = 0
                var index = 0
                var forloopcounter = 0
                for periodo in meses {
                    if(dat.levenshteinDistanceScore(to: periodo) > maxScore){
                        maxScore = dat.levenshteinDistanceScore(to: periodo)
                        index = forloopcounter
                    }
                    forloopcounter = forloopcounter + 1
                }
                billData["PeriodoFinal"] = endPeriod.trimmingCharacters(in: .whitespacesAndNewlines)
                print("Closest Match:")
                billData["PeriodoFinal"] = meses[index]
                print(meses[index])
            }
            else{
                //findClosestDate(date: endPeriod)
            }
        }
        
        if(periodsArray[0].count > 1){
            let dat = initialPeriod.trimmingCharacters(in: .whitespacesAndNewlines)
            var maxScore:Double = 0
            var index = 0
            var forloopcounter = 0
            for periodo in meses {
                if(dat.levenshteinDistanceScore(to: periodo) > maxScore){
                    maxScore = dat.levenshteinDistanceScore(to: periodo)
                    index = forloopcounter
                }
                forloopcounter = forloopcounter + 1
            }
            billData["PeriodoInicial"] = initialPeriod.trimmingCharacters(in: .whitespacesAndNewlines)
            print("Closest Match:")
            billData["PeriodoInicial"] = meses[index]
            print(meses[index])
        }
        else{
            //findClosestDate(date: initialPeriod)
        }
        
        print("******")
        print("Period")
        print(billData["PeriodoInicial"]!)
        print(billData["PeriodoFinal"]!)
        print("******")
        
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        var img = results.scannedImage
        if(results.enhancedImage != nil){
            img = results.enhancedImage!
        }
        let context = CIContext(options: nil)
        let currentFilter = CIFilter(name: "CIPhotoEffectNoir")
        currentFilter!.setValue(CIImage(image: img), forKey: kCIInputImageKey)
        let output = currentFilter!.outputImage
        let cgimg = context.createCGImage(output!,from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        img  = processedImage
        
        let contextSharpen = CIContext(options: nil)
        let parameters = [
            "inputSharpness": NSNumber(value: 1.0)
        ]
        let currentFilterSharp = CIFilter(name: "CISharpenLuminance", parameters: parameters)
        currentFilterSharp!.setValue(CIImage(image: img), forKey: kCIInputImageKey)
        let outputSharp = currentFilterSharp!.outputImage
        let cgimgSharp = contextSharpen.createCGImage(outputSharp!,from: outputSharp!.extent)
        let processedImageSharp = UIImage(cgImage: cgimg!)
        img  = processedImageSharp
        //img = resizeImage(image: img, newWidth: 500)!
        /*
         let glContext = EAGLContext(api: .openGLES2)!
         let ciContext = CIContext(eaglContext: glContext, options: [CIContextOption.outputColorSpace : NSNull()])
         let filter = CIFilter(name: "CIPhotoEffectMono")
         filter!.setValue(CIImage(image: img), forKey: "inputImage")
         let outputImage = filter!.outputImage
         let cgimg2 = ciContext.createCGImage(outputImage!, from: (outputImage?.extent)!)
         let processedImage2 = UIImage(cgImage: cgimg2!)
         img = processedImage2
         let contextNoise = CIContext(options: nil)
         let currentFilterNoise = CIFilter(name: "CIVignetteEffect")
         currentFilterNoise!.setValue(CIImage(image: img), forKey: kCIInputImageKey)
         currentFilterNoise!.setValue(0.3, forKey: "inputIntensity")
         currentFilterNoise!.setValue(0.2, forKey: "inputRadius")
         let outputNoise = currentFilterNoise!.outputImage
         let cgimgNoise = contextNoise.createCGImage(outputNoise!,from: outputNoise!.extent)
         let processedImageNoise = UIImage(cgImage: cgimgNoise!)
         img  = processedImageNoise*/
        
        
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
        tesseract.image = img
        
        tesseract.image = img
        tesseract.recognize()
        recognizedText = tesseract.recognizedText!
        print("XXXXXX")
        print("The text is")
        print(tesseract.recognizedText!)
        saveFoundData()
        scanner.dismiss(animated: true)
        

    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true)

    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        print(error)
        scanner.dismiss(animated: true)

    }
    
    var recognizedText = ""
    let tarifas = ["1", "1a", "dac", "1b", "1c", "1d", "1e", "1f"];
    let meses = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"]
    
    let scannerViewController = ImageScannerController()
    let tesseract:G8Tesseract = G8Tesseract(language: "spa")
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        scannerViewController.imageScannerDelegate = self
        present(scannerViewController, animated: true)
        //SeleccionarRecibo.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func increaseContrast(_ image: UIImage) -> UIImage {
        let inputImage = CIImage(image: image)!
        let parameters = [
            "inputContrast": NSNumber(value: 1)
        ]
        let outputImage = inputImage.applyingFilter("CIColorControls", parameters: parameters)
        
        let context = CIContext(options: nil)
        let img = context.createCGImage(outputImage, from: outputImage.extent)!
        return UIImage(cgImage: img)
    }
    func increaseBrightness(_ image: UIImage) -> UIImage {
        let inputImage = CIImage(image: image)!
        let parameters = [
            "inputBrightness": NSNumber(value: 0.0)
        ]
        let outputImage = inputImage.applyingFilter("CIColorControls", parameters: parameters)
        
        let context = CIContext(options: nil)
        let img = context.createCGImage(outputImage, from: outputImage.extent)!
        return UIImage(cgImage: img)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[.originalImage] as? UIImage {
            self.dismiss(animated: true, completion: nil)
        } else{
            print("Something went wrong")
        }
    }
    func shouldCancelImageRecognition(for tesseract: G8Tesseract!) -> Bool {
        return false
    }
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let next = segue.destination as! ManualReceiptViewController
        next.receivedBillData = self.billData
        let backItem = UIBarButtonItem()
        backItem.title = "Regresar"
        navigationItem.backBarButtonItem = backItem
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
}
