//
//  CGSize+.swift
//

import Foundation

public extension CGSize {
    
    public var isZero: Bool {
        return width < LENGTH_EPSILON || height < LENGTH_EPSILON
    }
    
    public var roundSize: CGSize {
        return CGSize(round(self.width), round(self.height))
    }
    
    public func shrink(by multiple: CGFloat) -> CGSize {
        return CGSize(self.width / multiple, self.height / multiple)
    }
    
    public func enlarge(by multiple: CGFloat) -> CGSize {
        return CGSize(self.width * multiple, self.height * multiple)
    }
    
    public var squareMin: CGSize {
        let value = min(self.width, self.height)
        return CGSize(value, value)
    }
    
    public var squareMax: CGSize {
        let value = max(self.width, self.height)
        return CGSize(value, value)
    }
    
    public func multiply(by value: CGFloat) -> CGSize {
        return CGSize(self.width * value, self.height * value)
    }
}


public func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
    return CGRect(x: x, y: y, width: width, height: height)
}
