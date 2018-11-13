//
//  Int+.swift
//
//  需求：超过万时保留一位小数，若最后一位小数为0，则取整数
//       超过亿时保留两位小数，若最后一位小数为0，则去掉0；若两位都是0，则取整数

import UIKit

public extension Int {
    
    public func mpNumber(showZero: Bool = false) -> String {
        
        if self <= 0 {
            return  showZero ? "0" : ""
        }
        
        if self < 10000 {
            return "\(self)"
        }
        
        if self < 100000000 {
            let num = Int( round( Double(self) / 1000 ) )
            let integer = num / 10
            let fraction = num - integer * 10
            return "\(integer).\(fraction)万"
        }
        
        let num = Int( round( Double(self) / 10000000 ) )
        let integer = num / 10
        let fraction = num - integer * 10
        return "\(integer).\(fraction)亿"
    }
    
    // format seconds to text
    public func mpTimeDesc(_ isEnglish: Bool = false) -> String {
        
        if self <= 0 {
            return ""
        }
        
        let minutes = self / 60
        let seconds = self % 60
        
        var text = ""
        
        if minutes > 0 {
            if isEnglish {
                text += "\(minutes)min"
            } else {
                text += "\(minutes)分"
            }
            
        }
        if seconds > 0 {
            if isEnglish {
                text += "\(seconds)s"
            } else {
                text += "\(seconds)秒"
            }
        }
        
        return text
    }
    
    public static func random(from: UInt, to: UInt) -> Int {
        if to <= from {
            return Int(to)
        }
        let r = Int(arc4random() % UInt32(to - from)) + Int(from)
        return r
    }
    
    
    public func likeOrCommentCountText() -> String {
        
        let skinDresserMaxLikeOrCommentCount: Int = 999
        
        if self > skinDresserMaxLikeOrCommentCount {
            return "\(skinDresserMaxLikeOrCommentCount)+"
        } else if self > 0 {
            return "\(self)"
        }
        return ""
    }
}

public extension Int64 {
    public var dataSizeDesc: String {
        
        let suffix = ["B", "KB", "MB", "GB"]
        
        var suffixIndex = 0
        
        var decimal: Int64 = self
        var fraction: Int64 = 0
        
        while (decimal > 1024) && (suffixIndex < suffix.count) {
            suffixIndex += 1
            
            let tmp = decimal * 10 / 1024
            
            decimal = tmp / 10
            fraction = tmp % 10
        }

        return "\(decimal).\(fraction)\(suffix[suffixIndex])"
    }
}

public class RefInt: NSObject {
    @objc public dynamic var value: Int = 0
}
