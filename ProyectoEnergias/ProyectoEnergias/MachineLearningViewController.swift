//
//  MachineLearningViewController.swift
//  EcoBook
//
//  Created by Ali Bryan Villegas Zavala on 5/6/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//


import UIKit
import SceneKit
import ARKit
import Vision

class MachineLearningViewController: UIViewController, ARSCNViewDelegate {
    
    private var hitTestResult: ARHitTestResult!
    private var resnetModel = bulbModel()
    private var visionRequests = [VNRequest]()
    var dataObj: [Any]?
    var dataStringURL = "http://martinmolina.com.mx/201911/data/ProyectoEnergiasRenovables/mlConsumption.json"
    var deviceConsumption = [String:Any]()
    
    //1. cargar el modelo de la red
    //2. registrar el gesto de tap
    //3. instanciar el modelo y enviar la imagen
    //4. Presentar los datos resultados del modelo
    
    @IBAction func tapEjecutado(_ sender: UITapGestureRecognizer) {
        //obtener la vista donde se va a trabajar
        let vista = sender.view as! ARSCNView
        //ubicar el toque en el centro de la vista
        let ubicacionToque = self.sceneView.center
        //obtener la imagen actual
        guard let currentFrame = vista.session.currentFrame else {return}
        //obtener los nodos que fueron tocados por el rayo
        let hitTestResults = vista.hitTest(ubicacionToque, types: .featurePoint)
        
        if (hitTestResults .isEmpty){
            //no se toco nada
            return}
        guard var hitTestResult = hitTestResults.first else{
            return
            
        }
        //obtener la imagen capturada en formato de buffer de pixeles
        let imagenPixeles = currentFrame.capturedImage
        self.hitTestResult = hitTestResult
        performVisionRequest(pixelBuffer: imagenPixeles)
    }
    
    private func performVisionRequest(pixelBuffer: CVPixelBuffer)
    {
        //inicializar el modelo de ML al modelo usado, en este caso resnet
        let visionModel = try! VNCoreMLModel(for: resnetModel.model)
        let request = VNCoreMLRequest(model: visionModel) { request, error in
            
            if error != nil {
                print(error)
                return}
            guard let observations = request.results else {
                //no hubo resultados por parte del modelo
                return
                
            }
            //obtener el mejor resultado
            let observation = observations.first as! VNClassificationObservation
            
            print("Nombre \(observation.identifier) confianza \(observation.confidence)")
            if observation.confidence > 0.8 {
                self.showAlertOfFoundObject(foundObjectString: observation.identifier)

            }
            else {
                let alert = UIAlertController(title: "Oops", message: "No pudimos identificar el objeto, intenta con otro", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Entendido", style: .default, handler: nil))
                self.present(alert, animated: true)
            }

        }
        //la imagen que se pasará al modelo sera recortada para quedarse con el centro
        request.imageCropAndScaleOption = .centerCrop
        self.visionRequests = [request]
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .upMirrored, options: [:])
        DispatchQueue.global().async {
            try! imageRequestHandler.perform(self.visionRequests)
            
        }
        
        removeSpinner()
        
    }
    
    private func showAlertOfFoundObject(foundObjectString: String){
        var consumo = 100.0
        print("Found object")
        print(foundObjectString)
        consumo = deviceConsumption[foundObjectString.trimmingCharacters(in: .whitespacesAndNewlines)] as! Double
        var msgAlert:String = "¿Sabías que en promedio un "
        msgAlert += foundObjectString
        msgAlert += " consume "
        msgAlert += "\(consumo)"
        msgAlert += "KWh por mes?"
        if foundObjectString == "Incandescente" || foundObjectString == "Focoahorrador" {
            msgAlert = "¿Sabías que en promedio un "
            msgAlert += foundObjectString
            msgAlert += " consume "
            msgAlert += "\(consumo)"
            msgAlert += "KWh por mes?"
        }
        
        let alert = UIAlertController(title: foundObjectString, message: msgAlert, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ver Gráfica Comparativa", style: .default,handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "goToGraph", sender: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: nil))
        
        self.present(alert, animated: true)
        
        removeSpinner()
    }
    
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let alert = UIAlertController(title: "¿Cómo funciona?", message: "Toca el centro de la pantalla para identificar el objeto", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entendido", style: .default, handler: nil))
        self.present(alert, animated: true)
        var dataURL = URL(string:dataStringURL)
        let data = try? Data(contentsOf: dataURL!)
        dataObj = try!JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)  as? [AnyObject]
        print("DATAOBJ\(dataObj)")
        var mapDictionary = dataObj?[0] as! [String:Any]
        print("MAP\(mapDictionary)")
        deviceConsumption = mapDictionary
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
