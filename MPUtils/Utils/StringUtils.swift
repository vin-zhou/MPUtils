//
//  StringUtils.swift
//

import Foundation

open class StringUtils {
    
    open class func isEmpty(_ string : String?) -> Bool {
        if let aString = string {
            return aString.isEmpty
        }
        return true
    }
    
    fileprivate static var _emojiFontHeightMap: [String: CGSize] = [:]
    
    open class func emojiHeightOfFontSize(_ size: CGFloat) -> CGSize {
        
        let key = "\(Int(size))"
        if let size = _emojiFontHeightMap[key] {
            return size
        }
        
        let demoEmoji = "😁"
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: size)
        label.text = demoEmoji
        label.sizeToFit()
        
        let size = label.frame.size
        _emojiFontHeightMap[key] = size
        return size
    }
    
    
    fileprivate static let letters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    open class func randomStringWithLength(_ length: Int) -> String {
        
        let randomString = NSMutableString(capacity: length)
        
        for _ in 0..<length {
            let pos: Int = Int(arc4random_uniform(UInt32(letters.length)))
            randomString.appendFormat("%C", letters.character(at: pos))
        }
        
        return randomString as String
    }
    
    open class func weiboDesc(prefix: String = "", desc: String, suffix: String) -> String {
//        let max = 280
//        let result = "\(prefix)\(desc.appendEllipsisFromByte(max - prefix.meipuByteLength - suffix.meipuByteLength - 1)) \(suffix)"
//        return result
        return "\(prefix)\(desc) \(suffix)" // 取消微博140个字字数限制
    }
    
}
