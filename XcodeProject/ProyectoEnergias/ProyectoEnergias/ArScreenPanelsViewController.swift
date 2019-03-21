
//
//  ViewController.swift
//  AR101
//
//  Created by Ali Bryan Villegas Zavala on 3/11/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ArScreenPanelsViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        
        // Create a new scene
        // let scene = SCNScene(named: "art.scnassets/Godzilla.scn")!
        let scene =    SCNScene()
        let esfera    =    SCNBox(width: 2.0, height: 2.0, length: 2.0, chamferRadius: 0)
        let materialTierra =    SCNMaterial()
        materialTierra.diffuse.contents =    UIImage(named:"panelSolar.png")
        materialTierra.isDoubleSided = true
        let tierra    =    SCNNode()
        tierra.geometry =    esfera
        tierra.geometry?.materials =    [materialTierra]
        tierra.position =    SCNVector3(x:0,    y:0,    z:-5)
        scene.rootNode.addChildNode(tierra)
        /*sceneView.debugOptions =    [ARSCNDebugOptions.showWorldOrigin]
         let scene =    SCNScene()
         let box    =    SCNBox(width:    1,    height:    1,    length:    1,    chamferRadius:    0)
         let material    =    SCNMaterial()
         material.diffuse.contents =    UIColor.green
         let node =    SCNNode()
         node.geometry =    box
         node.geometry?.materials =    [material]
         node.position =    SCNVector3(x:    0,    y:    0,    z:-2)
         scene.rootNode.addChildNode(node)
         // Set the scene to the view*/
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
