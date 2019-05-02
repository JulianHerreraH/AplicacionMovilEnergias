//
//  ARTutorialReciboViewController.swift
//  EcoBook
//
//  Created by Ali Bryan Villegas Zavala on 4/30/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARTutorialReciboViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/mancuerna.dae")!
        
        // Set the scene to the view
        //sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARImageTrackingConfiguration()
        guard let imagenesMarcador = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)
            else{
                fatalError("No se encontró la imagen marcadora")
        }
        
        configuration.trackingImages = imagenesMarcador
        
        // Create a session configuration
        //let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor){
        if let anchor = anchor as? ARImageAnchor{
            let imagenReferencia = anchor.referenceImage
            agregarModelo(to:node, refImage: imagenReferencia)
        }
    }
    
    private func agregarModelo(to node:SCNNode,refImage:ARReferenceImage ){
        DispatchQueue.global().async {
            //currentFrame es la imagen actual de la camara
            guard let currentFrame = self.sceneView.session.currentFrame else {return}
            
            //let path = Bundle.main.path(forResource: "CheeziPuffs", ofType: "mov")
            //let url = URL(fileURLWithPath: path!)
            
            let moviePath = "http://martinmolina.com.mx/201911/data/ProyectoEnergiasRenovables/Videos/360-Solar-ES.mov"
            
            let url = URL(string: moviePath)
            let player = AVPlayer(url: url!)
            player.volume = 0.5
            print(player.isMuted)
            
            // crear un nodo capaz de reporducir un video
            let videoNodo = SKVideoNode(avPlayer: player)                //let videoNodo = SKVideoNode(fileNamed: "CheeziPuffs.mov")
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
            pantallaPlanaNodo.position = SCNVector3(pantallaPlanaNodo.position.x,pantallaPlanaNodo.position.y, pantallaPlanaNodo.position.z - 0.2)
            self.sceneView.scene.rootNode.addChildNode(pantallaPlanaNodo)
            
            /*
             //let escenaModelo = SCNScene(named: "art.scnassets/mancuerna.dae")!
             guard let currentFrame = self.sceneView.session.currentFrame else {return}
             
             let moviePath = "https://www.youtube.com/watch?v=wLcWf8fN54o&frags=pl%2Cwn"
             let url = URL(string: moviePath)
             let player = AVPlayer(url: url!)
             player.volume = 0.5
             print(player.isMuted)
             
             let videoNodo = SKVideoNode(url: url!)
             videoNodo.play() //ejecutar play al momento de presentarse
             
             let spriteKitEscene =  SKScene(size: CGSize(width: 640, height: 480))
             spriteKitEscene.addChild(videoNodo)
             
             videoNodo.position = CGPoint(x: spriteKitEscene.size.width/2, y: spriteKitEscene.size.height/2)
             videoNodo.size = spriteKitEscene.size
             
             let pantalla = SCNPlane(width: 0.75, height: 0.5)
             
             pantalla.firstMaterial?.diffuse.contents = spriteKitEscene
             //permitir ver el video por ambos lados
             pantalla.firstMaterial?.isDoubleSided = true
             
             let pantallaPlanaNodo = SCNNode(geometry: pantalla)
             //identificar en donde se ha tocado el currentFrame
             var traduccion = matrix_identity_float4x4
             //definir un metro alejado del dispositivo
             traduccion.columns.3.z = -1.0
             pantallaPlanaNodo.simdTransform = matrix_multiply(currentFrame.camera.transform, traduccion)
             
             pantallaPlanaNodo.eulerAngles = SCNVector3(Double.pi-10, 0, 0)
             //encontrar    el    nodo    principal:    Brazalete
             //let nodoPrincipal = escenaModelo.rootNode.childNode(withName:"movie",recursively:    true)!
             node.addChildNode(pantallaPlanaNodo)
             */
        }
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
