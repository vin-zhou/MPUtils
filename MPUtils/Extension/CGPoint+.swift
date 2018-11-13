//
//  CGPoint+.swift
//

import Foundation

public extension CGPoint {
    
    public static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    public static func += (left: inout CGPoint, right: CGPoint) {
        left = left + right
    }

    public static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    public static func -= (left: inout CGPoint, right: CGPoint) {
        left = left - right
    }
    
    public static func * (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x * right.x, y: left.y * right.y)
    }
    
    public static func * (left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x * right, y: left.y * right)
    }
    
    public static func *= (left: inout CGPoint, right: CGPoint) {
        left = left * right
    }

    public static func *= (left: inout CGPoint, right: CGFloat) {
        left = left * right
    }

    public static func / (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x / right.x, y: left.y / right.y)
    }
    
    public static func /= (left: inout CGPoint, right: CGPoint) {
        left = left / right
    }
}
