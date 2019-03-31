//
//  CameraShowViewController.swift
//  ProyectoEnergias
//
//  Created by Ali Bryan Villegas Zavala on 3/20/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit

import TesseractOCR

extension String {
    func levenshteinDistanceScore(to string: String, ignoreCase: Bool = true, trimWhiteSpacesAndNewLines: Bool = true) -> Double {
        
        var firstString = self
        var secondString = string
        
        if ignoreCase {
            firstString = firstString.lowercased()
            secondString = secondString.lowercased()
        }
        if trimWhiteSpacesAndNewLines {
            firstString = firstString.trimmingCharacters(in: .whitespacesAndNewlines)
            secondString = secondString.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        let empty = [Int](repeating:0, count: secondString.count)
        var last = [Int](0...secondString.count)
        
        for (i, tLett) in firstString.enumerated() {
            var cur = [i + 1] + empty
            for (j, sLett) in secondString.enumerated() {
                cur[j + 1] = tLett == sLett ? last[j] : Swift.min(last[j], last[j + 1], cur[j])+1
            }
            last = cur
        }
        
        // maximum string length between the two
        let lowestScore = max(firstString.count, secondString.count)
        
        if let validDistance = last.last {
            return  1 - (Double(validDistance) / Double(lowestScore))
        }
        
        return 0.0
    }
}

class CameraShowViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, G8TesseractDelegate {
    var recognizedText = ""
    let tarifas = ["1", "1A", "1B", "1C", "1D", "1E", "1F"];
    let meses = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"]
    @IBOutlet weak var imageView: UIImageView!
    let tesseract:G8Tesseract = G8Tesseract(language: "spa")
    @IBOutlet weak var addRecibo: UIButton!
    @IBOutlet weak var SeleccionarRecibo: UIButton!
    let imagePicker = UIImagePickerController()
    var billData:[String:String] = ["CostoTotal": "?",
                                "PeriodoInicial": "?",
                                "PeriodoFinal": "?",
                                "Tarifa": "?",
                                "ConsumoTotal" : "?"]
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        addRecibo.layer.cornerRadius = 5
        //SeleccionarRecibo.layer.cornerRadius = 5
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
            var img = chosenImage
            imageView.image = img

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
            tesseract.image = imageView.image
            
            tesseract.image = img
            tesseract.recognize()
            recognizedText = tesseract.recognizedText!
            print("XXXXXX")
            print("The text is")
            print(tesseract.recognizedText!)
            saveFoundData()
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
        if(recognizedText.contains("(ah)")){
            var splittedText = text.components(separatedBy: "(ah)")
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
        print("******")
        print("TARIFA")
        billData["Tarifa"] = tariffType
        print(billData["Tarifa"]!)
        print("******")
        
    }
    func readAndUpdatePeriods( text: String){
        var splittedText = text.components(separatedBy: "facturado:")
        var periods = splittedText[1]
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
                print(meses[index])
            }
            else{
                //findClosestDate(date: endPeriod)
            }
        }
       
        if(periodsArray[0].count > 1){
            var dat = initialPeriod.trimmingCharacters(in: .whitespacesAndNewlines)
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
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Regresar"
        navigationItem.backBarButtonItem = backItem
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
