//
//  Geometry.swift
//  ARNinja
//
//  Created by Harry Jordan on 07/09/2017.
//  Copyright © 2017 Christopher Batin. All rights reserved.
//

import Foundation
import SceneKit
import ModelIO
import SceneKit.ModelIO


class GeometryFactory {

    static func randomNodeGeometry() -> SCNGeometry {
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
    
    
    static func title() -> SCNNode {
        let scene = SCNScene(named: "Title.scn")!
        return scene.rootNode.childNodes[0]
    }
    
    
    static func meerkat() -> SCNNode {
        let url = Bundle.main.url(forResource: "meerkat", withExtension: "obj", subdirectory: "Models/Meerkat")!
        let assets = MDLAsset(url: url)
        
        let meerkat = SCNNode(mdlObject: assets.object(at: 0))
        meerkat.scale = SCNVector3(0.002, 0.002, 0.002)
        return meerkat
    }


}
