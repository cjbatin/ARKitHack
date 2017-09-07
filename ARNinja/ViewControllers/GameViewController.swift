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

<<<<<<< HEAD:ARNinja/ViewControllers/GameViewController.swift
class GameViewController: UIViewController, ARSCNViewDelegate {

=======
class ViewController: UIViewController, ARSCNViewDelegate {
>>>>>>> plane-detection:ARNinja/ViewController.swift
    @IBOutlet weak var sceneView: ARSCNView!
    let scene = SCNScene(named: "RootScene.scn")!
    let effectManager = EffectManager()
    
    var spawnTime:TimeInterval = 0
    
    var isInitialFrame: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Set the scene to the view
        sceneView.isPlaying = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
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
    
    func spawnShape() {
        let geometry = GeometryFactory.randomNodeGeometry()
        
        let randomRed = CGFloat(arc4random_uniform(255))
        let randomBlue = CGFloat(arc4random_uniform(255))
        let randomGreen = CGFloat(arc4random_uniform(255))
        geometry.materials.first?.diffuse.contents = UIColor.init(red: (randomRed/255), green: (randomGreen/255), blue: (randomBlue/255), alpha: 1.0)
        
        let geometryNode = SCNNode(geometry: geometry)
        let randomX = Float.random(min: -5, max: 5)
        let randomY = Float.random(min: -5, max: 5)
        let randomZ = Float.random(min: -5, max: 5)
        
        let position = SCNVector3(x: randomX, y: randomY, z: randomZ)
        
        let force = SCNVector3(x: 0, y: 1 , z: 0)
//        geometryNode.physicsBody?.applyForce(force, at: position, asImpulse: true)
        geometryNode.position = position
//        geometryNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        
<<<<<<< HEAD:ARNinja/ViewControllers/GameViewController.swift
        scene.rootNode.addChildNode(geometryNode)
=======
        
        scene.rootNode.addChildNode(geometryNode)
        effectManager.add(effect:.shimmer, toNode: geometryNode)
        effectManager.add(effect:.rain, toNode: scene.rootNode)
>>>>>>> plane-detection:ARNinja/ViewController.swift
    }
    
    
    func cleanScene() {
        for node in scene.rootNode.childNodes {
            if node.presentation.position.y < -5 {
                node.removeFromParentNode()
            }
        }
    }
    
    @objc func tapped(recognizer: UIGestureRecognizer) {
        gameDidFinish(withScore: 5)
    }
    func gameDidFinish(withScore:Int) {
        sceneView.session.pause()
        sceneView.isPlaying = false
        HighscoresManager().updateScores(newScore: withScore)
        lastScore = withScore
        self.performSegue(withIdentifier: "toGameOver", sender: self)
    }

}

<<<<<<< HEAD:ARNinja/ViewControllers/GameViewController.swift
extension GameViewController : SCNSceneRendererDelegate {
=======

extension ViewController : SCNSceneRendererDelegate {

>>>>>>> plane-detection:ARNinja/ViewController.swift
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        if isInitialFrame {
            let meerkat = GeometryFactory.meerkat()
            meerkat.position = SCNVector3Make(0.0, 0.0, -1000.0)
            
            scene.rootNode.addChildNode(meerkat)
            isInitialFrame = false
            
//            self.effectManager.perform(animation: [], onNode: meerkat) {
//                meerkat.removeFromParentNode()
//            }
        }
//        cleanScene()

    }
    
}
