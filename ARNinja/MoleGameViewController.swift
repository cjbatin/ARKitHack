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

    var gameController: GameController!

    let maxMeerkats = 3
    @IBOutlet weak var sceneView: ARSCNView!
    let scene = SCNScene()

    var spawnTime: TimeInterval = 0
    var spriteScene: SKScene!
    var scoreLabel: SKLabelNode!
    var timeLabel: SKLabelNode!
    
    private var planes: [UUID: FloorPlaneNode] = [:]
    private var meerkats: [SCNNode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let game = Game()
        gameController = GameController(
            game: game,
            delegate: self
        )
        
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
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(screenTapped))
        sceneView.addGestureRecognizer(tapGesture)

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left

        timeLabel = SKLabelNode(fontNamed: "Chalkduster")
        timeLabel.text = "Time: 60"
        timeLabel.horizontalAlignmentMode = .right

        updateSprites()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        updateSprites(size: size)
    }

    func updateSprites(size: CGSize? = nil) {
        sceneView.overlaySKScene = nil

        spriteScene = SKScene(size: size ?? self.view.bounds.size)

        scoreLabel.removeFromParent()
        scoreLabel.position = CGPoint(x: 400, y: 300)
        spriteScene.addChild(scoreLabel)

        timeLabel.removeFromParent()
        timeLabel.position = CGPoint(x: 200, y: 300)
        spriteScene.addChild(timeLabel)

        sceneView.overlaySKScene = spriteScene
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
        
        // TODO: subtract width and height
        let w = Float((width)/2.0) //Float((width - geometry.width)/2.0)
        let h = Float((height)/2.0) // Float((height - geometry.height)/2.0)
        let x = Float.random(min: -w, max: w)
        let z = Float.random(min: -h, max: h)

        
        let molePositionOnFloor = SCNVector3(x: x , y: 0, z: z)
        let molePositionInWorld = floorPlane.convertPosition(molePositionOnFloor, to: nil)
        
        print("molePositionOnFloor = \(molePositionOnFloor.y), molePositionInWorld=\(molePositionInWorld.y), floorPane.y= \(floorPlane.position.y)")

        meerkat.position = molePositionInWorld
        meerkat.name = "meerkat"

        
        meerkats.append(meerkat)
        self.scene.rootNode.addChildNode(meerkat)
        playSound(state: .spawn)
    }
    
    func cleanOldMeerkats() {
        
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
    
    @objc func screenTapped(recognizer: UIGestureRecognizer) {
        let sceneView = recognizer.view as! SCNView
        let touchLocation = recognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(touchLocation, options: [:])
        
        if !hitResults.isEmpty{
            let node = hitResults[0].node
            if node.name == "meerkat"{
                node.removeFromParentNode()
                gameController.tapped()
                playSound(state: .whacked)            }
        }
        
    }
    
    func playSound(state: MoleStatus) {
        
        let resource: String
        
        switch state {
        case .spawn:
            resource = "twang"
        case .whacked:
            resource = "squelch"
        }
        
        let url = Bundle.main.url(forResource: resource, withExtension: "mp3")!
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            //guard let player = player else { return }
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
}
extension MoleGameViewController : SCNSceneRendererDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {

        gameController.update()

        if meerkats.count >= maxMeerkats {
            let meerkatToRemove = meerkats.remove(at: 0)
            meerkatToRemove.removeFromParentNode()
        }
     
    }
}


extension MoleGameViewController: GameControllerDelegate {

    func spawn(target:Target) {
        spawnMole()
    }

    func gameDidFinish(withScore:Int) {
        sceneView.session.pause()
        sceneView.isPlaying = false
        HighscoresManager().updateScores(newScore: withScore)
        lastScore = withScore
        self.performSegue(withIdentifier: "toGameOver", sender: self)
    }

    func timeRemainingUpdated(to:TimeInterval) {}
    func scoreUpdated(to:Int) {}
}

enum MoleStatus{
    case spawn
    case whacked
}
