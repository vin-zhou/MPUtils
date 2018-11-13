//
//  CGFloat+.swift

import UIKit

public extension CGFloat {
    public static var max : CGFloat {
        return CGFloat(MAXFLOAT)
    }
    
    public var chtFloorValue: CGFloat {
        // 和waterFallLayout一致，避免显示的宽高和设置的不一样
        return floor(self * ScreenScale) / ScreenScale
    }
    
}
