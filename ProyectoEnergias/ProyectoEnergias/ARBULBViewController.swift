//
//  ARBULBViewController.swift
//  EcoBook
//
//  Created by Ali Bryan Villegas Zavala on 4/9/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//
//
//  ViewController.swift
//  Foco2.0
//

import UIKit
import SceneKit
import ARKit


class ARBULBViewController: UIViewController, ARSCNViewDelegate {
    
    
    @IBOutlet var sceneView: ARSCNView!
    var bulb = SCNNode()
    var bulbCounter = 0
    var isNormalBulb = true
    var textureURL = "http://martinmolina.com.mx/201911/data/ProyectoEnergiasRenovables/Videos/bulb-texture.jpg"
    @IBAction func escalar(_ sender: UIPinchGestureRecognizer) {
        print ("sender Scale")
        print(sender.scale)
        
        print(bulb.scale)
        let pinchScaleX: CGFloat = sender.scale * CGFloat((bulb.scale.x))
        let pinchScaleY: CGFloat = sender.scale * CGFloat((bulb.scale.y))
        let pinchScaleZ: CGFloat = sender.scale * CGFloat((bulb.scale.z))
        sender.scale = 1
            
        
        
        if isNormalBulb{
            if bulb.scale.x > 2{
                bulb.scale = SCNVector3Make(Float(1), Float(1), Float(1))
            }else{
                bulb.scale = SCNVector3Make(Float(pinchScaleX), Float(pinchScaleY), Float(pinchScaleZ))
                
            }
        }else{
        bulb.scale = SCNVector3Make(Float(pinchScaleX), Float(pinchScaleY), Float(pinchScaleZ))
        }
        sceneView.reloadInputViews()
    }
    
    /*
     @IBAction func swipe(_ sender: UISwipeGestureRecognizer) {
     bulb.eulerAngles = SCNVector3(sender.state.rawValue,sender.state.rawValue + 90,0)
     let location2 = sender.location(in: view)
     print(location2)
     }
     */
    /*
     @IBAction func pan(_ sender: UIPanGestureRecognizer) {
     bulb.eulerAngles = SCNVector3(sender.state.rawValue,sender.state.rawValue ,sender.state.rawValue)
     let location2 = sender.location(in: view)
     print(location2)
     }
     */
    
    @IBAction func rotation(_ sender: UIRotationGestureRecognizer) {
        print("Rotating")
        if isNormalBulb{
            //bulb.eulerAngles = SCNVector3(sender.rotation * -1.0,CGFloat(bulb.rotation.y),CGFloat(bulb.rotation.z))
        }else{

            bulb.eulerAngles = SCNVector3(CGFloat(bulb.rotation.x),sender.rotation * -1.0,CGFloat(bulb.rotation.z))
            
        }
        sceneView.reloadInputViews()
        
    }
    
    /*
     @IBAction func ejecucionTap(_ sender: UITapGestureRecognizer) {
     if let filePath = Bundle.main.path(forResource: "bulb", ofType: "scn", inDirectory: "art.scnassets") {
     // ReferenceNode path -> ReferenceNode URL
     let referenceURL = URL(fileURLWithPath: filePath)
     // Create reference node
     let referenceNode = SCNReferenceNode(url: referenceURL)
     referenceNode?.load()
     bulb = referenceNode!
     }
     self.sceneView.scene.rootNode.addChildNode(bulb)
     let location2 = sender.location(in: view)
     print(location2)
     
     }
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("loades fine ")
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        sceneView.autoenablesDefaultLighting = true //necesario para que se muestre la luz especular
        let alert = UIAlertController(title: "¿Cómo funciona?", message: "Toca el centro de la pantalla para crear un objeto, 2 veces para borrarlo", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Create a new scene
        let scene = SCNScene()
        //        let scene = SCNScene(named: "art.scnassets/bulb2.scn")!
        self.sceneView.scene = scene
        
        self.focoRifador()
        
        scene.rootNode.addChildNode(self.bulb)
        
        self.sceneView.scene = scene
        
        
    }
    
    func focoRifador()
    {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTap.numberOfTapsRequired = 1
        let tapGesto = UITapGestureRecognizer(target: self, action: #selector(tapEnPantalla))
        tapGesto.numberOfTapsRequired = 2
        
        //let tapGesto = UITapGestureRecognizer(target: self, action: #selector(tapEnPantalla))
        //let rotGesto = UIRotationGestureRecognizer(target: self, action: #selector(rotFigura))
        
        self.sceneView.addGestureRecognizer(tapGesto)
        self.sceneView.addGestureRecognizer(doubleTap)
        //self.sceneView.addGestureRecognizer(rotGesto)
        
    }
    
    @objc func tapEnPantalla(manejador:UIGestureRecognizer)
    {
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.bulbCounter = 0
            
        }
        
    }
    
    @objc func doubleTapped(manejador:UIGestureRecognizer)
    {
        print("borrado")
        
        guard let currentFrame = self.sceneView.session.currentFrame else {return}
        let location2 = manejador.location(in: view)
        print(location2)
        
        if bulbCounter != 1{
            // IF model cannot be loaded from JSON, it takes local model
            if var filePath = Bundle.main.path(forResource: "bulb2", ofType: "scn", inDirectory: "art.scnassets") {
                print("FOCO FOUND")
                //self.sceneView.scene = SCNScene(named: "art.scnassets/bulb2.scn")!
                // ReferenceNode path -> ReferenceNode URL
                var referenceURL = URL(fileURLWithPath: "http://martinmolina.com.mx/201911/data/ProyectoEnergiasRenovables/Videos/bulb2.scn")
                if !isNormalBulb {
                    referenceURL = URL(fileURLWithPath: "http://martinmolina.com.mx/201911/data/ProyectoEnergiasRenovables/Videos/cfl_bulb.scn")
                    filePath = Bundle.main.path(forResource: "cfl_bulb", ofType: "scn", inDirectory: "art.scnassets")!
                }
                do {
                    let scene = try SCNScene(url: referenceURL, options: nil)
                    self.sceneView.scene = scene
                    
                }
                catch{}
                
                referenceURL = URL(fileURLWithPath: filePath)
                print("URL")
                print(referenceURL)
                // Create reference node
                let referenceNode = SCNReferenceNode(url: referenceURL)
                referenceNode?.load()
                bulb = referenceNode!
                
                if !isNormalBulb{
                     var material = SCNMaterial()
                     var texture = UIImageView()
                     //texture.imageFromURL(urlString: textureURL)
                     texture.image = UIImage(named: "art.scnassets/texture")
                    print(texture.image)
                     material.diffuse.contents = texture.image
                    material.locksAmbientWithDiffuse = true
                    
                     bulb.geometry?.firstMaterial? = material
                    bulb.geometry?.materials = [material]
                    /*
                     bulb.childNode(withName: "ceramicbase_default", recursively: true)!.geometry?.firstMaterial? = material
                     bulb.childNode(withName: "bottomceramic_default", recursively: true)!.geometry?.firstMaterial? = material
                     bulb.childNode(withName: "screwcap_default", recursively: true)!.geometry?.firstMaterial? = material*/
                }
                
            }
            //sceneView.pointOfView?.addChildNode(bulb!)
            var traduccion = matrix_identity_float4x4
            //definir un metro alejado del dispositivo
            traduccion.columns.3.z = -1.0
            bulb.simdTransform = matrix_multiply(currentFrame.camera.transform, traduccion)
            self.sceneView.scene.rootNode.addChildNode(bulb)
            //bulb.position = SCNVector3Make(0, 0, -5)
        }
        
        bulbCounter = 1
    }
    /*
     @objc func rotFigura(manejador:UIRotationGestureRecognizer)
     {
     bulb.eulerAngles = SCNVector3(0,manejador.rotation,0)
     let location2 = manejador.location(in: view)
     print(location2)
     
     
     }
     */
    /*
     @objc func escalado(recognizer:UIPinchGestureRecognizer)
     {
     
     bulb.scale = SCNVector3(recognizer.scale, recognizer.scale, recognizer.scale)
     
     }
     */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        sceneView.allowsCameraControl = false
        // Run the view's session
        sceneView.session.run(configuration)
    }
    func gestureRecognizer(_: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
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
