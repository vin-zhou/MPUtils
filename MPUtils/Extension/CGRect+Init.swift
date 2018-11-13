//
//  CGRect+Init.swift
//

import UIKit

public extension CGRect {
    
    public init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
    
    public init(center: CGPoint, size: CGSize) {
        self.init(center.x - size.width/2.0 , center.y - size.height/2.0, size.width, size.height)
    }

    public func applyInsets(_ insets: UIEdgeInsets) -> CGRect {
        return CGRect(origin.x + insets.left, origin.y + insets.top, width - insets.left - insets.right, height - insets.top - insets.bottom)
    }
}

public extension CGSize {
    
    public init(_ width:CGFloat,_ height:CGFloat) {
        self.init(width:width,height:height)
    }
}

public extension CGPoint {
    
    public init(_ x:CGFloat,_ y:CGFloat) {
        self.init(x:x,y:y)
    }
}

public extension UIEdgeInsets {
    
    public init(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) {
        self.init(top: top, left: left, bottom: bottom, right: right)
    }
    
}

