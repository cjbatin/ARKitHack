//
//  MoleGameViewController.swift
//  ARNinja
//
//  Created by Ben Callis on 07/09/2017.
//  Copyright © 2017 Christopher Batin. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class MoleGameViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    let scene = SCNScene()
    var spawnTime:TimeInterval = 0
    
    private var planes: [UUID: FloorPlaneNode] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        // Create a new scene
        
        // Set the scene to the view
        sceneView.scene = scene
        sceneView.delegate = self
        sceneView.isPlaying = true
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(screenTapped:))
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal
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
    

    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func spawnMole() {
        
        guard planes.count > 0 else { return }
        
        let floorPlaneNumber = Int(arc4random_uniform(UInt32(planes.count)))
        let allPlanes = Array(planes.values)
        let floorPlane = allPlanes[floorPlaneNumber]
        
        let width = floorPlane.plane.width
        let height = floorPlane.plane.height

        // TODO: Chnage to a 3d mole
        let meerkat = GeometryFactory.meerkat()
        let geometry = meerkat.geometry!
        
        // TODO: subtract width and height
        let w = Float((width)/2.0) //Float((width - geometry.width)/2.0)
        let h = Float((height)/2.0) // Float((height - geometry.height)/2.0)
        let x = Float.random(min: -w, max: w)
        let z = Float.random(min: -h, max: h)

        
        let molePositionOnFloor = SCNVector3(x: x , y: 0, z: z)
        let molePositionInWorld = floorPlane.convertPosition(molePositionOnFloor, to: nil)
        
        print("molePositionOnFloor = \(molePositionOnFloor.y), molePositionInWorld=\(molePositionInWorld.y), floorPane.y= \(floorPlane.position.y)")

       // let geometryNode = SCNNode(geometry: geometry)
        meerkat.position = molePositionInWorld
        
        self.scene.rootNode.addChildNode(meerkat)
    }
    
    func cleanScene() {
        for node in scene.rootNode.childNodes {
            if node.presentation.position.y < -5 {
                node.removeFromParentNode()
            }
        }
    }
}

extension MoleGameViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {

        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        
        let floorPlaneNode = FloorPlaneNode(anchor: planeAnchor)
        node.addChildNode(floorPlaneNode)
        
        self.planes[anchor.identifier] = floorPlaneNode
        
        spawnMole()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let existingPlane = self.planes[anchor.identifier], let newPlaneAnchor =  anchor as? ARPlaneAnchor else {
            return
        }
        existingPlane.update(for: newPlaneAnchor)
    }

    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        if let plane = self.planes.removeValue(forKey: anchor.identifier) {
            plane.removeFromParentNode()
        }
        
    }
    
    func screenTapped(recognizer: UIGestureRecognizer) {
        let sceneView = recognizer.view as! SCNView
        let touchLocation = recognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(touchLocation, options: [:])
        
        if !hitResults.isEmpty{
            let node = hitResults[0].node
            node.removeFromParentNode()
        }
        
    }
    
}
extension MoleGameViewController : SCNSceneRendererDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // 3
        if time > spawnTime {
            spawnMole()
            
            // 2
            spawnTime = time + TimeInterval(Float.random(min: 0.2, max: 1))
        }
        //cleanScene()
    }
}
