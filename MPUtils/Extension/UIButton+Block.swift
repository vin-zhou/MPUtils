//
//  UIButton+Block.swift
//

import UIKit

open class ControlBlockTarget : NSObject{
    
    open var block:(Any) -> Void
    open var controlEvents:UIControl.Event
    
    public init(for controlEvents:UIControl.Event,with block:@escaping (Any) -> Void){
        self.controlEvents = controlEvents
        self.block = block
    }
    
    @objc open dynamic func invoke(_ sender:Any){
        self.block(sender)
    }
}

public var key_blockControlTargets = "key_blockControlTargetsZZZ"
public extension UIButton{
    
    public func addActionBlock(for controlEvents: UIControl.Event,with actionBlock:@escaping (Any)->Void) {
        let target = ControlBlockTarget(for: controlEvents, with: actionBlock)
        self.addTarget(target, action:#selector(ControlBlockTarget.invoke(_:)), for: controlEvents)
        self.blockTargets.add(target)
    }
    
    public var blockTargets:NSMutableArray {
        if let blockTargets = objc_getAssociatedObject(self, &key_blockControlTargets) as? NSMutableArray {
            return blockTargets
        }
        else{
            let blockTargets = NSMutableArray()
            objc_setAssociatedObject(self, &key_blockControlTargets, blockTargets,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            return blockTargets
        }
    }
}


