//
//  UIView+Border.swift
//

import Foundation
import UIKit
import SnapKit

private let ViewTagValue = 100000

public enum ViewBorderType: Int {
    case top = 1
    case left = 2
    case bottom = 3
    case right = 4
    public static var allValues: [ViewBorderType] = [.top, .left, .bottom, .right]
}

public class ViewBorder: NSObject {
    
    var type      : ViewBorderType = .bottom
    var thickness : CGFloat      = 0.5
    var color     : UIColor      = UIColor.mpE4E4E4Color()
    var insets    : UIEdgeInsets = UIEdgeInsets()
    
    public init(_ type: ViewBorderType) {
        self.type = type
    }
    
    public convenience init(_ type: ViewBorderType, thickness: CGFloat) {
        self.init(type)
        self.thickness = thickness
    }
    
    public convenience init(_ type: ViewBorderType, color: UIColor) {
        self.init(type)
        self.color = color
    }
    
    public convenience init(_ type: ViewBorderType, insets: UIEdgeInsets) {
        self.init(type)
        self.insets = insets
    }
    
    public convenience init(_ type: ViewBorderType, thickness: CGFloat, color: UIColor) {
        self.init(type, thickness: thickness)
        self.color = color
    }
    
    public convenience init(_ type: ViewBorderType, thickness: CGFloat, color: UIColor, insets: UIEdgeInsets) {
        self.init(type, thickness: thickness, color: color)
        self.insets = insets
    }
}

public extension UIView {
    
    // We'll ensure no duplicated border inside.
    public func addBorders(_ borders: [ViewBorder]) {
        for  border in borders {
            addBorder(border)
        }
    }
    
    // We'll ensure only remove the existed border inside.
    public func removeBorders(_ borders: [ViewBorder]) {
        for border in borders {
            removeBorder(border)
        }
    }
    
    
    //////////
    // Private: Our methods call these to add their borders.
    //////////
    
    private func addBorder(_ border: ViewBorder) {
        var isExist = false
        for subview in subviews {
            if subview.tag == ViewTagValue + border.type.rawValue {
                isExist = true
                break;
            }
        }
        if !isExist {
            createBorder(border)
        }
    }
    
    private func removeBorder(_ border: ViewBorder) {
        var existBorderView: UIView?
        for subview in subviews {
            if subview.tag == ViewTagValue + border.type.rawValue {
                existBorderView = subview
                break;
            }
        }
        if let borderView = existBorderView {
            borderView.removeFromSuperview()
        }
    }
    
    private func createBorder(_ border: ViewBorder) {
        let type         = border.type
        let thickness    = border.thickness
        let color        = border.color
        let leftOffset   = border.insets.left
        let rightOffset  = border.insets.right
        let topOffset    = border.insets.top
        let bottomOffset = border.insets.bottom
        
        let borderView = _getOneSidedBorder(color)
        borderView.tag = ViewTagValue + border.type.rawValue
        switch type {
        case .top:
            // Bottom Offset Has No Effect
            borderView.snp.remakeConstraints({ (make) in
                make.left.equalTo(self).offset(leftOffset)
                make.top.equalTo(self).offset(topOffset)
                make.right.equalTo(self).offset(-rightOffset)
                make.height.equalTo(thickness)
            })
        case .right:
            // Left Has No Effect
            borderView.snp.remakeConstraints({ (make) in
                make.right.equalTo(self).offset(-rightOffset)
                make.top.equalTo(self).offset(topOffset)
                make.bottom.equalTo(self).offset(-bottomOffset)
                make.width.equalTo(thickness)
            })
        case .bottom:
            // Top has No Effect
            borderView.snp.remakeConstraints({ (make) in
                make.left.equalTo(self).offset(leftOffset)
                make.bottom.equalTo(self).offset(-bottomOffset)
                make.right.equalTo(self).offset(-rightOffset)
                make.height.equalTo(thickness)
            })
        case .left:
            // Right Has No Effect
            borderView.snp.remakeConstraints({ (make) in
                make.left.equalTo(self).offset(leftOffset)
                make.top.equalTo(self).offset(topOffset)
                make.bottom.equalTo(self).offset(-bottomOffset)
                make.width.equalTo(thickness)
            })
        }
    }
    
    private func _getOneSidedBorder(_ color: UIColor) -> UIView {
        let borderView: UIView = UIView.init()
        borderView.backgroundColor = color
        self.addSubview(borderView)
        return borderView
    }
    
}
