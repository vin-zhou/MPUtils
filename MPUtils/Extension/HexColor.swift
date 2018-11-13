//
//  HexColor.swift
//

import Foundation
import UIKit

public extension UIColor {
    
    /// Initializes UIColor with an integer.
    ///
    /// - parameter value: The integer value of the color. E.g. 0xFF0000 is red, 0x0000FF is blue.
    public convenience init(_ value: Int64) {
        let components = getColorComponents(value)
        self.init(red: components.red, green: components.green, blue: components.blue, alpha: 1.0)
    }
    
    /// Initializes UIColor with an integer and alpha value.
    ///
    /// - parameter value: The integer value of the color. E.g. 0xFF0000 is red, 0x0000FF is blue.
    /// - parameter alpha: The alpha value.
    public convenience init(_ value: Int64, alpha: CGFloat) {
        let components = getColorComponents(value)
        self.init(red: components.red, green: components.green, blue: components.blue, alpha: alpha)
    }
    
    /// Creates a new color with the given alpha value
    ///
    /// For example, (0xFF0000).alpha(0.5) defines a red color with 50% opacity.
    ///
    /// - returns: A UIColor representation of the Int with the given alpha value
    public func alpha(_ value:CGFloat) -> UIKit.UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return UIKit.UIColor(red: red, green: green, blue: blue, alpha: value)
    }
    
    /// Mixes the color with another color
    ///
    /// - parameter color: The color to mix with
    /// - parameter amount: The amount (0-1) to mix the new color in.
    /// - returns: A new UIColor instance representing the resulting color
    public func mixWithColor(_ color:UIColor, amount:Float) -> UIColor {
        var comp1: [CGFloat] = Array(repeating: 0, count: 4);
        var r1 = comp1[0]
        var g1 = comp1[1]
        var b1 = comp1[2]
        var a1 = comp1[3]
        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        
        var comp2: [CGFloat] = Array(repeating: 0, count: 4);
        var r2 = comp2[0]
        var g2 = comp2[1]
        var b2 = comp2[2]
        var a2 = comp2[3]
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        var comp: [CGFloat] = Array(repeating: 0, count: 4);
        for i in 0...3 {
            comp[i] = comp1[i] + (comp2[i] - comp1[i]) * CGFloat(amount)
        }
        
        return UIColor(red:comp[0], green: comp[1], blue: comp[2], alpha: comp[3])
    }
    
    public convenience init(rgba: Int64) {
        let components = getColorComponents((rgba >> 8) & 0xFFFFFF)
        let alpha = CGFloat(rgba & 0xFF) / 255.0
        self.init(red: components.red, green: components.green, blue: components.blue, alpha: alpha)
    }
}

private func getColorComponents(_ value: Int64) -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
    let r = CGFloat(value >> 16 & 0xFF) / 255.0
    let g = CGFloat(value >> 8 & 0xFF) / 255.0
    let b = CGFloat(value & 0xFF) / 255.0
    
    return (r, g, b)
}
