//
//  ARVIDEOSViewController.swift
//  EcoBook
//
//  Created by Ali Bryan Villegas Zavala on 4/9/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARVIDEOSViewController: UIViewController, ARSCNViewDelegate {
    var is360 = ""
    var receivedURL = ""
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let alert = UIAlertController(title: "¿Cómo funciona?", message: "Toca el centro de la pantalla para iniciar el video", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { // Change `2.0` to the desired
            let scene = SCNScene()
            
            // Set the scene to the view
            self.sceneView.scene = scene
            self.registerGestureRecognizer()
        }
        // Set the view's delegate
    }
    private func registerGestureRecognizer()
    {
        let tapGesto = UITapGestureRecognizer(target: self, action: #selector(tapEnPantalla))
        self.sceneView.addGestureRecognizer(tapGesto)
    }
    
    @objc func tapEnPantalla(manejador:UIGestureRecognizer)
    {
        showSpinner(onView: self.view)
        if(is360 == "true"){
            guard let currentFrame = self.sceneView.session.currentFrame else {return}
            let moviePath = receivedURL
            let url = URL(string: moviePath)
            let player = AVPlayer(url: url!)
            player.volume = 0.5
            print(player.isMuted)
            
            // crear un nodo capaz de reporducir un video
            let videoNodo = SKVideoNode(url: url!)
            
            videoNodo.play() //ejecutar play al momento de presentarse
            
            //crear una escena sprite kit, los parametros estan en pixeles
            let spriteKitEscene =  SKScene(size: CGSize(width: 950, height: 720))
            
            videoNodo.position = CGPoint(x: spriteKitEscene.size.width/2, y: spriteKitEscene.size.height/2)
            videoNodo.size = spriteKitEscene.size
            
            spriteKitEscene.addChild(videoNodo)
            
            let esfera = SCNSphere(radius:20.0)
            let materialVideo = SCNMaterial()
            materialVideo.diffuse.contents = spriteKitEscene
            materialVideo.isDoubleSided = true
            
            var transform = SCNMatrix4MakeRotation(Float.pi, 0.0, 0.0, 1.0)
            transform = SCNMatrix4Translate(transform, 1.0, 1.0, 0.0)
            materialVideo.diffuse.contentsTransform = transform
            let energia = SCNNode()
            energia.geometry = esfera
            energia.geometry?.materials = [materialVideo]
            energia.position = SCNVector3(0.0,0.0,0.0)
            
            self.sceneView.scene.rootNode.addChildNode(energia)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.removeSpinner()
            }
        }
        else {
            
            guard let currentFrame = self.sceneView.session.currentFrame else {return}
            
            //let path = Bundle.main.path(forResource: "CheeziPuffs", ofType: "mov")
            //let url = URL(fileURLWithPath: path!)
            
            let moviePath = receivedURL
            
            let url = URL(string: moviePath)
            let player = AVPlayer(url: url!)
            player.volume = 0.5
            print(player.isMuted)
            
            // crear un nodo capaz de reporducir un video
            let videoNodo = SKVideoNode(url: url!)
            //let videoNodo = SKVideoNode(fileNamed: "CheeziPuffs.mov")
            //let videoNodo = SKVideoNode(avPlayer: player)
            videoNodo.play() //ejecutar play al momento de presentarse
            
            //crear una escena sprite kit, los parametros estan en pixeles
            let spriteKitEscene =  SKScene(size: CGSize(width: 640, height: 480))
            spriteKitEscene.addChild(videoNodo)
            
            //colocar el videoNodo en el centro de la escena tipo SpriteKit
            videoNodo.position = CGPoint(x: spriteKitEscene.size.width/2, y: spriteKitEscene.size.height/2)
            videoNodo.size = spriteKitEscene.size
            
            //crear una pantalla 4/3, los parametros son metros
            let pantalla = SCNPlane(width: 1.0, height: 0.75)
            
            //pantalla.firstMaterial?.diffuse.contents = UIColor.blue
            //modificar el material del plano
            pantalla.firstMaterial?.diffuse.contents = spriteKitEscene
            //permitir ver el video por ambos lados
            pantalla.firstMaterial?.isDoubleSided = true
            
            let pantallaPlanaNodo = SCNNode(geometry: pantalla)
            //identificar en donde se ha tocado el currentFrame
            var traduccion = matrix_identity_float4x4
            //definir un metro alejado del dispositivo
            traduccion.columns.3.z = -1.0
            pantallaPlanaNodo.simdTransform = matrix_multiply(currentFrame.camera.transform, traduccion)
            
            pantallaPlanaNodo.eulerAngles = SCNVector3(Double.pi, 0, 0)
            self.sceneView.scene.rootNode.addChildNode(pantallaPlanaNodo)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.removeSpinner()
            }
        }
        //currentFrame es la imagen actual de la camara
       
        
        
        
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
