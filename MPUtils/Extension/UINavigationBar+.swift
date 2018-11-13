//
//  UINavigationBar+.swift
//

import UIKit

public extension UINavigationBar {
    public func showShadowImage() {
        self.shadowImage = UIImage.imageOfColor(UIColor.mpSeparatorColor(), size: CGSize(UIScreen.main.bounds.size.width, 0.5))
    }
    
    public func hideShadowImage() {
        self.shadowImage = UIImage()
    }
}
/*
extension UINavigationBar {
    override open func addSubview(_ view: UIView?) {
        // the 'view' maybe is nil
        if let view = view {
            super.addSubview(view)
            
            // the 'view' is 'UINavigationItemButtonView'
            // in search controller, it will be added to navigationBar when back by gestrue
//            if String(describing: type(of: view)) == "UINavigationItemButtonView" {
//                view.isHidden = true
//            }
        }
       

    }

}
*/
