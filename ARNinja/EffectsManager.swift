//
//  Effects.swift
//  ARNinja
//
//  Created by Harry Jordan on 07/09/2017.
//  Copyright © 2017 Christopher Batin. All rights reserved.
//

import Foundation
import SceneKit


enum Animation {
//    fadeOut()
}

enum Effect: String {
    case shimmer
    case rain
    case explode
    
    var particleFileName: String {
        return self.rawValue
    }
    
}


typealias EffectToken = String

class EffectManager {
    var effectsForTokens: [EffectToken: SCNParticleSystem] = [:]
    
    
    func perform(animation: [Animation], onNode node: SCNNode, completionBlock: (() -> Void)?) {
        CATransaction.begin()
        
        let animation = CABasicAnimation()
        animation.fromValue = 1.0
        animation.toValue = 0.5
        animation.duration = 10.0
        animation.autoreverses = true
        animation.repeatCount = 10
        node.addAnimation(animation, forKey: "opacity")

//        CATransaction.setCompletionBlock(completionBlock)
        
        CATransaction.commit()
    }
    
    @discardableResult func add(effect: Effect, toNode node: SCNNode) -> EffectToken {
        let particleSystem = SCNParticleSystem(named: effect.particleFileName, inDirectory: nil)!
        particleSystem.warmupDuration = 20.0
        
        if let geometry = node.geometry {
            particleSystem.emitterShape = geometry
        }
        
        node.addParticleSystem(particleSystem)
        
        let token = NSUUID().uuidString
        effectsForTokens[token] = particleSystem
        return token
    }
    
    
    func remove(effectForToken token: EffectToken, fromNode node: SCNNode) {
        guard let particleSystem = effectsForTokens[token] else { return }
        
        node.removeParticleSystem(particleSystem)
    }
    
    
}
