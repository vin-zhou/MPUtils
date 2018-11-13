//
//  UIBarButtonItem+.swift
//

import UIKit

public extension UIBarButtonItem {
    public func mpTintColor(_ color: UIColor) {
        mpTintColor(color, state: .normal)
    }
    
    public func mpTintColor(_ color: UIColor, state: UIControl.State) {
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:color], for: state)
    }
}

public extension UIBarButtonItem {
    fileprivate struct AssociatedKeys {
        static var keyName_SystemStyle    : UInt = 1
    }
    
    @objc public class func startSwizz() {
        let before: Method = class_getInstanceMethod(UIBarButtonItem.self, #selector(UIBarButtonItem.init(barButtonSystemItem:target:action:)))!
        let after: Method  = class_getInstanceMethod(UIBarButtonItem.self, #selector(UIBarButtonItem.sw_init(barButtonSystemItem:target:action:)))!
        method_exchangeImplementations(before, after)
    }

    public var customSystemStyle : UIBarButtonItem.SystemItem? {
        get {
            if let result = objc_getAssociatedObject(self, &AssociatedKeys.keyName_SystemStyle) as? NSNumber {
                if let style = UIBarButtonItem.SystemItem(rawValue: result.intValue) {
                    return style
                }
            }
            return nil
        }
        set(newValue) {
            if let value = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.keyName_SystemStyle, NSNumber(value: value.rawValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                objc_removeAssociatedObjects(self)
            }
        }
    }
    
    @objc public func sw_init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem, target: AnyObject?, action: Selector) -> UIBarButtonItem {
        let item = sw_init(barButtonSystemItem: systemItem, target: target, action: action)
        item.customSystemStyle = systemItem
        return item
    }
}
