//
//  UIView+.swift
//

import UIKit

public extension UIView {
    public func convert2Image() -> UIImage? {
        let s: CGSize = self.bounds.size
        UIGraphicsBeginImageContextWithOptions(s, false, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    public func takeScreenshot() -> UIImage? {
        let s: CGSize = self.bounds.size
        UIGraphicsBeginImageContextWithOptions(s, false, UIScreen.main.scale)
        self.drawHierarchy(in: CGRect(0, 0, s.width, s.height), afterScreenUpdates: true)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    public func takeScreenshot(_ completion: @escaping (_ capturedImage: UIImage?) -> Void) {
        GCDUtils.delay(0.3) {
            completion(self.takeScreenshot())
        }
    }
    
}

public extension UIView {
    
    public func makeRotation(_ angle: CGFloat, animated: Bool = false) {
        if animated {
            UIView.animate(withDuration: 0.25, animations: {
                self.transform = CGAffineTransform(rotationAngle: angle)
            })
        } else {
            self.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    public func clearRotation(_ animated: Bool = false) {
        if animated {
            UIView.animate(withDuration: 0.25, animations: {
                self.transform = CGAffineTransform.identity
            })
        } else {
            self.transform = CGAffineTransform.identity
        }
    }
    
    public func rotation(angle: Double, repeatCount: Int, duration: Double = 1) {
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnim.fromValue = 0
        rotationAnim.toValue = angle
        rotationAnim.repeatCount = Float(repeatCount)
        rotationAnim.duration = duration
        rotationAnim.isRemovedOnCompletion = false
        rotationAnim.fillMode = CAMediaTimingFillMode.forwards
        self.layer.add(rotationAnim, forKey: nil)
    }
}

public extension UIView {
    public func scale(_ value: CGFloat) {
        let size = self.frame.size
        guard !size.isZero else {
            return
        }
        let rect = self.frame
        self.transform = CGAffineTransform(scaleX: value, y: value)
        self.frame = CGRectMake(rect.origin.x * value, rect.origin.y * value, rect.size.width * value, rect.size.height * value)
    }
}

public extension UIView {
    public func moveY(from: CGFloat, to: CGFloat, duration: Double, elasticEnabled: Bool = false) {
        let moveLayer = self.layer
        
        let moveAnimation = CAKeyframeAnimation(keyPath: "position.y")
        if elasticEnabled {
            let toY = to + self.height/2
            moveAnimation.values = [from + self.height/2, toY + 10, toY]  // centerY
            moveAnimation.keyTimes = [0, 0.8, 1]
        } else {
            moveAnimation.values = [from + self.height/2, to + self.height/2]  // centerY
        }
        moveAnimation.duration = duration
        moveAnimation.repeatCount = 1
        moveAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        moveAnimation.isRemovedOnCompletion = false
        moveAnimation.autoreverses = false
        moveAnimation.fillMode = CAMediaTimingFillMode.forwards
        moveLayer.add(moveAnimation, forKey: "move")
        
        self.top = to
    }
}

public class ViewTransform: NSObject {
    
    public var completion: (() -> Void)?
    
    public func moveBezier(view: UIView, from: CGPoint, to: CGPoint, control: CGPoint, duration: Double, alphaEnabled: Bool = true, scaleEnable: Bool = false, timeFunction: CAMediaTimingFunctionName = CAMediaTimingFunctionName.easeInEaseOut) {
        
        let moveLayer = view.layer
        
        let animationGroup = CAAnimationGroup()
        animationGroup.fillMode = CAMediaTimingFillMode.forwards
        animationGroup.delegate = self
        animationGroup.duration = duration
        animationGroup.isRemovedOnCompletion = true
        animationGroup.timingFunction = CAMediaTimingFunction(name: timeFunction)
        
        var animations: [CAKeyframeAnimation] = []
        
        let animationPosition = CAKeyframeAnimation(keyPath: "position")
        animationPosition.fillMode = CAMediaTimingFillMode.forwards
        animationPosition.timingFunction = CAMediaTimingFunction(name: timeFunction)
        animationPosition.duration = duration
        
        let path: CGMutablePath = CGMutablePath()
        path.move(to: CGPoint(x: CGFloat(from.x), y: CGFloat(from.y)), transform: .identity)
        path.addQuadCurve(to: CGPoint(x: CGFloat(to.x), y: CGFloat(to.y)), control: CGPoint(x: CGFloat(control.x), y: CGFloat(control.y)), transform: .identity)
        animationPosition.path = path
        animations.append(animationPosition)
        
        if alphaEnabled {
            let animationAlpha = CAKeyframeAnimation(keyPath: "opacity")
            animationAlpha.values = [1, 0.8, 0]
            animationAlpha.keyTimes = [0, 0.5, 1]
            animationAlpha.fillMode = CAMediaTimingFillMode.forwards
            animationAlpha.timingFunction = CAMediaTimingFunction(name: timeFunction)
            animationAlpha.duration = duration
            animations.append(animationAlpha)
            
            moveLayer.opacity = 0
        }
        
        if scaleEnable {
            let animationScale = CAKeyframeAnimation(keyPath: "transform.scale")
            animationScale.fillMode = CAMediaTimingFillMode.forwards
            animationScale.values = [1, 0.6, 0]
            animationScale.keyTimes = [0, 0.7, 1]
            animationScale.timingFunction = CAMediaTimingFunction(name: timeFunction)
            animationScale.duration = duration
            animations.append(animationScale)
        }
        
        animationGroup.animations = animations
        
        moveLayer.add(animationGroup, forKey: "move")
    }

}

extension ViewTransform: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        completion?()
    }
}
