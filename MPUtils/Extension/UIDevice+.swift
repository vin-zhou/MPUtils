//
//  UIDevice+.swift
//

import Foundation
import UIKit

public extension UIDevice {
    
    public static var modelName: String {
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        //iPods
        case "iPod5,1":                                     return "iPod Touch 5"
        case "iPod7,1":                                     return "iPod Touch 6"
            
        //iPhones
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":         return "iPhone 4"
        case "iPhone4,1":                                   return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                      return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                      return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                      return "iPhone 5s"
        case "iPhone7,2":                                   return "iPhone 6"
        case "iPhone7,1":                                   return "iPhone 6 Plus"
        case "iPhone8,1":                                   return "iPhone 6s"
        case "iPhone8,2":                                   return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                      return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                      return "iPhone 7 Plus"
        case "iPhone8,4":                                   return "iPhone SE"
        case "iPhone10,1","iPhone10,4":                     return "iPhone 8"
        case "iPhone10,2","iPhone10,5":                     return "iPhone 8 Plus"
        case "iPhone10,3","iPhone10,6":                     return "iPhone X"
        case "iPhone11,8":                                  return "iPhone XR"
        case "iPhone11,2":                                  return "iPhone XS"
        case "iPhone11,4","iPhone11,6":                     return "iPhone XS MAX"
            
        //iPads
        case "iPad1,1":                                     return "iPad"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":    return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":               return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":               return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":               return "iPad Air"
        case "iPad5,3", "iPad5,4":                          return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":               return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":               return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":               return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                          return "iPad Mini 4"
        case "iPad6,7", "iPad6,8", "iPad6,3", "iPad6,4":    return "iPad Pro"
        case "iPad6,11":                                    return "iPad (5th Generation)"
        case "iPad7,1","iPad7,2","iPad7,3","iPad7,4":       return "iPad Pro (2nd Generation)"
        //Watch
        case "Watch1,1", "Watch1,2" :                       return "Apple Watch (1st Generation)"
        case "Watch2,6", "Watch2,7" :                       return "Apple Watch Series 1"
        case "Watch2,3", "Watch2,4":                        return "Apple Watch Series 2"
        case "Watch3,2", "Watch3,3", "Watch3,4":            return "Apple Watch Series 3"
            
        //Others
        case "AppleTV5,3":                                  return "Apple TV"
        case "i386", "x86_64":                              return "Simulator"
        default:                                            return identifier
        }
    }
    
    public var isIPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    
    public var isIPad: Bool {
        return UIDevice().userInterfaceIdiom == .pad
    }
    
    public var iOSVersion: String {
        return UIDevice.current.systemVersion
    }
    
}

public extension  UIDevice {
    
    public class var isIPhoneX: Bool {
        //需要兼容模拟器，所以不能使用ModelName来判断，只能用高度
        let height = UIScreen.main.bounds.height
        if height == 812 || height == 896 {
            return true
        }
        return false
    }
    
    public class var defaultStatusBarHeight: CGFloat {
        if UIDevice.isIPhoneX {
            return 44
        }
        return 20
    }
    
    public class var defaultTopGuideHeight: CGFloat {
        return defaultStatusBarHeight + 44
    }
    
    public class var safeAreaInsets: UIEdgeInsets {
        if #available(iOS 11, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
        }
        return UIEdgeInsets.zero
    }
}
