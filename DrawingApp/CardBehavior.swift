//
//  CardBehavior.swift
//  DrawingApp
//
//  Created by Crafter on 4/17/19.
//  Copyright © 2019 Crafter. All rights reserved.
//
import UIKit


class CardBehavior: UIDynamicBehavior {
    
    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = false
        behavior.friction = Constants.behaviorFriction
        behavior.elasticity = Constants.behaviorElasticity
        behavior.resistance = Constants.behaviorResistance
        return behavior
    }()
    
    private func push(_ item: UIDynamicItem){
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        
        
        if let referenceBounds = dynamicAnimator?.referenceView?.bounds {
            let center = CGPoint(x: referenceBounds.midX, y: referenceBounds.midY)
            push.angle = (CGFloat.pi/2).arc4random
            switch (item.center.x, item.center.y) {
            case let (x, y) where x < center.x && y > center.y:
                push.angle = -1 * push.angle
            case let (x, y) where x > center.x:
                push.angle = y < center.y ? CGFloat.pi-push.angle: CGFloat.pi+push.angle
            default:
                push.angle = (CGFloat.pi*2).arc4random
            }
        }
                
       // push.angle = (2*CGFloat.pi).arc4random
        push.magnitude = CGFloat(1.0) + CGFloat(2.0).arc4random
        push.action = {[unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    
    func addItem(_ item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
    }
    
    func removeItem(_ item: UIDynamicItem) {
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
    }
    
    override init() {
        super.init()
        
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
}

extension CGFloat {
    var arc4random: CGFloat {
        return self * (CGFloat(arc4random_uniform(UInt32.max))/CGFloat(UInt32.max))
    }
}
