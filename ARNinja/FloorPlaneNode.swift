//
//  FloorPlaneNode.swift
//  ARNinja
//
//  Created by Ben Callis on 07/09/2017.
//  Copyright © 2017 Christopher Batin. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class FloorPlaneNode: SCNNode {
    
    let anchor: ARPlaneAnchor
    let plane: SCNPlane

    init(anchor: ARPlaneAnchor) {
        self.anchor = anchor
        self.plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        
        super.init()
        
        // Style the plane
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "grassTexture")
        self.updateTexture()

        self.plane.materials = [material]
        
        let planeNode = SCNNode(geometry: self.plane)
        planeNode.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        
        planeNode.transform = SCNMatrix4MakeRotation(-(Float.pi/2.0), 1.0, 0, 0)
        
        self.addChildNode(planeNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateTexture() {
        let material = self.plane.materials.first!
        
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(plane.width), Float(plane.height), 1)
        material.diffuse.wrapS = .repeat
        material.diffuse.wrapT = .repeat
    }
    
    
    func update(for anchor: ARPlaneAnchor) {
        // As the user moves around the extend and location of the plane
        // may be updated. We need to update our 3D geometry to match the
        // new parameters of the plane.
        
        self.plane.width = CGFloat(anchor.extent.x)
        self.plane.height = CGFloat(anchor.extent.z)
        
        // When the plane is first created it's center is 0,0,0 and the nodes
        // transform contains the translation parameters. As the plane is updated
        // the planes translation remains the same but it's center is updated so
        // we need to update the 3D geometry position
        
        self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        self.updateTexture()
    }
    
}
