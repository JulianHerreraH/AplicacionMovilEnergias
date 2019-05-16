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
    
    @IBOutlet weak var waitingLabel: UILabel!
    var billData:[String:String] = ["CostoTotal": "?",
                                    "PeriodoInicial": "?",
                                    "PeriodoFinal": "?",
                                    "Tarifa": "?",
                                    "ConsumoTotal" : "?",
                                    "yearInicial": "?",
                                    "yearFinal":"?"]
    func saveFoundData(){
        if(recognizedText != ""){
            recognizedText = recognizedText.trimmingCharacters(in: .whitespacesAndNewlines)
            recognizedText = recognizedText.replacingOccurrences(of: " ", with: "")
            recognizedText = recognizedText.lowercased()
            if(recognizedText.contains("$")){
                print("Found $ \n")
                readAndUpdateTotalCost(text: recognizedText)
            }
            if(recognizedText.contains("periodo") || recognizedText.contains("facturado:") ){
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
            //navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)

        }
    }
    // MARK: - Navigation
    func readAndUpdateTotalCost( text: String){
        var splittedText = text.components(separatedBy: "$")
        var costTxt = splittedText[1].components(separatedBy: ".")
        var onlyCost = costTxt[0]
        print("******")
        print("TOTAL COST")
        if onlyCost.count > 4 {
            billData["CostoTotal"] = String(removeNonNumbers(text: onlyCost).prefix(4))
        }
        else{
            billData["CostoTotal"] = removeNonNumbers(text: onlyCost)

        }
        billData["CostoTotal"] = removeNonNumbers(text: onlyCost)
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
        if(splittedText.count > 1){
            
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
                    billData["PeriodoFinal"] = meses[index]
                    maxScore = 0
                    index = 0
                    forloopcounter = 0
                    var finYear = "20" + String(endPeriod.suffix(4))
                    for year in years {
                        if(finYear.levenshteinDistanceScore(to: year) > maxScore){
                            maxScore = finYear.levenshteinDistanceScore(to: year)
                            index = forloopcounter
                        }
                        forloopcounter = forloopcounter + 1
                    }
                    billData["yearFinal"] = years[index]
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
                billData["PeriodoInicial"] = meses[index]

                maxScore = 0
                index = 0
                forloopcounter = 0
                
                var initYear = "20" + String(initialPeriod.suffix(2))
                for year in years {
                    if(initYear.levenshteinDistanceScore(to: year) > maxScore){
                        maxScore = initYear.levenshteinDistanceScore(to: year)
                        index = forloopcounter
                    }
                    forloopcounter = forloopcounter + 1
                }
                billData["yearInicial"] = years[index]
                print("Closest Match:")
                //billData["yearInicial"] = String(initialPeriod.suffix(4))
                print(meses[index])
            }
            else{
                //findClosestDate(date: initialPeriod)
            }
        }
        print("******")
        print("Period")
        
        print(billData["PeriodoInicial"]!)
        print(billData["PeriodoFinal"]!)
        print("******")
        
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        scanner.dismiss(animated: true)
        /*let alert = UIAlertController(title: "Procesando", message: "La imagen se está procesando, esperar un momento", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default,handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert,animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        }*/
        self.showSpinner(onView: self.view)
        var img = results.scannedImage
        waitingLabel.text = "Analizando imagen, favor de esperar"
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {  if(results.enhancedImage != nil){
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
            
            self.tesseract.pageSegmentationMode = .singleBlock
            self.tesseract.image = img
            self.tesseract.recognize()
            self.recognizedText = self.tesseract.recognizedText!
            print("XXXXXX")
            print("The text is")
            print(self.tesseract.recognizedText!)
            self.removeSpinner()
            self.saveFoundData()
        }

        
        
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        navigationController?.popViewController(animated: true)
        scanner.dismiss(animated: true)
        
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        print(error)
        scanner.dismiss(animated: true)
        navigationController?.popViewController(animated: true)
        
        
        
    }
    
    var recognizedText = ""
    let tarifas = ["1", "1a", "dac", "1b", "1c", "1d", "1e", "1f"];
    let meses = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"]
    let years = ["2019", "2018", "2017", "2016","2015","2014","2013","2012","2011","2010","2009","2008"]
    
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
        print("SEGUEEEEEEE")
        print(self.billData)
        let next = segue.destination as! ManualReceiptViewController
        next.receivedBillData = self.billData
        next.hasReceivedData = true
        let backItem = UIBarButtonItem()
        backItem.title = "Regresar"
 
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
}
