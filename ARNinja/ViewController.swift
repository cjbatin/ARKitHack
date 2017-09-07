//
//  ViewController.swift
//  ARNinja
//
//  Created by Christopher Batin on 07/09/2017.
//  Copyright © 2017 Christopher Batin. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    let scene = SCNScene()
    var spawnTime:TimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        
        // Set the scene to the view
        sceneView.scene = scene
        sceneView.delegate = self
        sceneView.isPlaying = true
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
    
    func spawnShape() {
        // 1
        let geometry = randomNodeGeometry()
        // 2

        // 4
        let randomRed = CGFloat(arc4random_uniform(255))
        let randomBlue = CGFloat(arc4random_uniform(255))
        let randomGreen = CGFloat(arc4random_uniform(255))
        geometry.materials.first?.diffuse.contents = UIColor.init(red: (randomRed/255), green: (randomGreen/255), blue: (randomBlue/255), alpha: 1.0)
        let geometryNode = SCNNode(geometry: geometry)
        let randomX = Float.random(min: -5, max: 5)
        let randomY = Float.random(min: -5, max: 5)
        let randomZ = Float.random(min: -5, max: 5)
        // 2
        let force = SCNVector3(x: 0, y: 1 , z: 0)
        // 3
        let position = SCNVector3(x: randomX, y: randomY, z: randomZ)
        // 4
        geometryNode.physicsBody?.applyForce(force, at: position, asImpulse: true)
        // 5
        geometryNode.position = position
        geometryNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        
        scene.rootNode.addChildNode(geometryNode)
        
    }
    
    func randomNodeGeometry() -> SCNGeometry {
        switch ShapeType.random() {
        case .Box:
            return SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
        case .Capsule:
            return SCNCapsule(capRadius: 1.0, height: 1.0)
        case .Cone:
            return SCNCone(topRadius: 1.0, bottomRadius: 1.0, height: 1.0)
        case .Cylinder:
            return SCNCylinder(radius: 1.0, height: 1.0)
        case .Pyramid:
            return SCNPyramid(width: 1.0, height: 1.0, length: 1.0)
        case .Sphere:
            return SCNSphere(radius: 1.0)
        case .Torus:
            return SCNTorus(ringRadius: 1.0, pipeRadius: 0.5)
        case .Tube:
            return SCNTube(innerRadius: 1.0, outerRadius: 1.0, height: 1.0)
        }
    }
    
    func cleanScene() {
        // 1
        for node in scene.rootNode.childNodes {
            // 2
            if node.presentation.position.y < -5 {
                // 3
                node.removeFromParentNode()
            }
        }
    }
}

extension ViewController : SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // 3
        if time > spawnTime {
            spawnShape()
            
            // 2
            spawnTime = time + TimeInterval(Float.random(min: 0.2, max: 1))
        }
//        cleanScene()
    }
}
