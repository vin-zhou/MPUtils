//
//  UIFont+Mp.swift
//

import Foundation
import UIKit

public extension UIFont {
    // 价格字体
    public class func mpLightNumberFont(_ size: CGFloat) -> UIFont {
        if let font = UIFont(name: "AvenirLTStd-Heavy", size: size) {
            return font
        }
        
        return mpFontOfSize(size)
    }
    
    public class func mpNumberFont(_ size: CGFloat) -> UIFont {
        if let font = UIFont(name: "AvenirLTStd-Black", size: size) {
            return font
        }
        
        return mpFontOfSize(size)
    }
    
    public class func mpNumberFont(_ size: CGFloat, style: String) -> UIFont {
        if let font = UIFont(name: "AvenirLTStd-\(style)", size: size) {
            return font
        }
        
        return mpFontOfSize(size)
    }
}

public extension UIFont {
    // icon 字体
    public class func mpIconFont(_ size: CGFloat) -> UIFont {
        if let font = UIFont(name: "iconfont", size: size) {
            return font
        }
        
        return mpFontOfSize(size)
    }
}

public extension UIFont {
    public func adapt2iPhone5() -> UIFont {
        if iPhone6AndAbove {
            return self
        }
        if let font = UIFont(name: self.fontName, size: self.pointSize-2) {
            return font
        }
        return self
    }
}

public extension UIFont {
    
    public class func mpLightFontOfSize(_ size: CGFloat) -> UIFont {
        
        var font: UIFont? = nil
        
        if #available(iOS 9.0, *) {
            font = UIFont(name: ".SFUIText-Light", size: size)
        } else {
            font = UIFont(name: ".HelveticaNeueInterface-Light", size: size)
        }
        
        if let font = font {
            return font
        } else {
            assertionFailure()
            return mpFontOfSize(size)
        }
    }
    
    public class func mpItalicFontOfSize(_ size: CGFloat) -> UIFont {
        return UIFont.italicSystemFont(ofSize: size)
    }
    
    public class func mpFontOfSize(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size)
    }
    
    public class func mpBoldFontOfSize(_ size: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: size)
    }
    
    public class func mpEmojiFont() -> UIFont {
        if UIScreen.main.bounds.size.width == 320.0 {
            return UIFont.mpFontOfSize(24)
        } else {
            return UIFont.mpFontOfSize(30)
        }
    }
    
    public var labelLineHeight: CGFloat {
        let label = UILabel()
        label.text = " "
        label.font = self
        label.sizeToFit()
        return label.height
    }
}
