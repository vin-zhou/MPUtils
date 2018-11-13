//
//  UIImage+.swift
//

import Foundation

public enum UIImageContentMode {
    case scaleToFill, scaleAspectFit, scaleAspectFill
}


public extension UIImage {
    
    public func imageOfScreenScale() -> UIImage? {
        return imageOfScale(UIScreen.main.scale)
    }
    
    public func imageOfScale(_ scale: CGFloat) -> UIImage? {
        
        if abs(scale - self.scale) < 0.000001 {
            return self
        }
        
        if let cgimage = self.cgImage {
            return UIImage(cgImage: cgimage, scale: scale, orientation: self.imageOrientation)
        }
        
        return nil
    }
    
    public func image(WithColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(CGBlendMode.normal)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.clip(to: rect, mask: cgImage!)
        color.setFill()
        context.fill(rect)
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image =  newImage {
            return image
        }
        return self
    }
    
    public class func imageOfColor(_ color: UIColor, size: CGSize = CGSize(width: 1, height: 1), cornerRadius: CGFloat = 0) -> UIImage? {
        
        assert((cornerRadius <= size.width / 2 && cornerRadius <= size.height / 2), "cornerRadius is bigger than rect")
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        var image: UIImage? = nil
        
        if cornerRadius == 0 {
            UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
            let context = UIGraphicsGetCurrentContext()!
            context.setFillColor(color.cgColor)
            context.fill(rect)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        else{
            UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
            let context = UIGraphicsGetCurrentContext()!
            context.setFillColor(color.cgColor)
            let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
            context.addPath(path.cgPath)
            context.fillPath()
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        return image
    }
        
    public func square() -> UIImage? {
        if self.size.width == self.size.height {
            return self
        }
        let width = min(self.size.width, self.size.height)
        let height = width
        let x = (self.size.width - width) / 2
        let y = (self.size.height - height) / 2
        let rect = CGRect(x: x, y: y, width: width, height: width)
        
        return crop(bounds: rect)
    }
    
    public func merge(_ image: UIImage) -> UIImage {
        if image.size.width > self.size.width || image.size.height > self.size.height {
            return self
        }
        UIGraphicsBeginImageContext(self.size)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        
        image.draw(in: CGRect(x: (self.size.width - image.size.width)/2,y: (self.size.height - image.size.height)/2, width: image.size.width, height: image.size.height))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = scaledImage {
            return image
        }
        return self
    }
    
    class public func blend(_ imageNames: [String], size: CGSize) -> UIImage? {
        guard imageNames.count > 0 else { return nil }
        UIGraphicsBeginImageContext(size)
        for i in 0..<imageNames.count {
            if let image = UIImage(named: imageNames[i]) {
                image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            }
        }
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    public func crop(bounds: CGRect) -> UIImage? {
        if let image = self.cgImage?.cropping(to: bounds){
            return UIImage(cgImage: image,
                           scale: self.scale, orientation: self.imageOrientation)
            
        }
        return self
    }
    
    public func resizeToAbsoluteSize(_ size: CGSize, scale: CGFloat, contentMode: UIView.ContentMode) -> UIImage? {
        if (size.width <= 0 || size.height <= 0) { return nil }
        let size = CGSize(width: size.width * scale, height: size.height * scale)
        UIGraphicsBeginImageContext(size)
        self.drawInRect(CGRect(0, 0, size.width, size.height), with: contentMode)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    public func resizeTo(_ size:CGSize, with contentMode: UIView.ContentMode) -> UIImage?{
        if (size.width <= 0 || size.height <= 0) { return nil }
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        self.drawInRect(CGRect(0, 0, size.width, size.height), with: contentMode)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    public func roundedImage(cornerRadius: CGFloat) -> UIImage {
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image =  newImage {
            return image
        }
        return self
    }
    
    public func drawInRect(_ rect:CGRect,with contentMode:UIView.ContentMode){
        let drawRect = UIImage.rectFit(rect: rect, size: self.size, with: contentMode)
        if (drawRect.size.width == 0 || drawRect.size.height == 0) { return }
        self.draw(in: drawRect)
    }
    
    public class func rectFit(rect:CGRect, size:CGSize,with mode:UIView.ContentMode) -> CGRect{
        var rect = rect.standardized
        var size = size
        size.width = size.width < 0 ? -size.width : size.width
        size.height = size.height < 0 ? -size.height : size.height
        let center = CGPoint(rect.midX, rect.midY)
        switch mode {
        case .scaleAspectFit:
            if (rect.size.width < 0.01 || rect.size.height < 0.01 ||
                size.width < 0.01 || size.height < 0.01) {
                rect.origin = center
                rect.size = CGSize.zero
            } else {
                var  scale:CGFloat = 0
                if (size.width / size.height < rect.size.width / rect.size.height) {
                    scale = rect.size.height / size.height
                } else {
                    scale = rect.size.width / size.width
                }
                size.width = scale * size.width
                size.height = scale * size.height
                rect.size = size
                rect.origin = CGPoint(center.x - size.width * 0.5, center.y - size.height * 0.5)
            }
        case .scaleAspectFill:
            if (rect.size.width < 0.01 || rect.size.height < 0.01 ||
                size.width < 0.01 || size.height < 0.01) {
                rect.origin = center
                rect.size = CGSize.zero
            } else {
                var scale:CGFloat = 0
                if (size.width / size.height < rect.size.width / rect.size.height) {
                    scale = rect.size.width / size.width
                } else {
                    scale = rect.size.height / size.height
                }
                size.width = scale * size.width
                size.height = scale * size.height
                rect.size = size
                rect.origin = CGPoint(center.x - size.width * 0.5, center.y - size.height * 0.5)
            }
        case .center:
            rect.size = size
            rect.origin = CGPoint(center.x - size.width * 0.5, center.y - size.height * 0.5)
        case .top:
            rect.origin.x = center.x - size.width * 0.5
            rect.size = size
        case .bottom:
            rect.origin.x = center.x - size.width * 0.5
            rect.origin.y += rect.size.height - size.height
            rect.size = size
        case .left:
            rect.origin.y = center.y - size.height * 0.5
            rect.size = size
        case .right:
            rect.origin.y = center.y - size.height * 0.5
            rect.origin.x += rect.size.width - size.width
            rect.size = size
        case .topLeft:
            rect.size = size
        case .topRight:
            rect.origin.x += rect.size.width - size.width
            rect.size = size
        case .bottomLeft:
            rect.origin.y += rect.size.height - size.height
            rect.size = size
        case .bottomRight:
            rect.origin.x += rect.size.width - size.width
            rect.origin.y += rect.size.height - size.height
            rect.size = size
        default:
            break
        }
        return rect
    }
    
    public func orientatedTransform() -> CGAffineTransform {
        
        let width  = self.size.width
        let height = self.size.height

        var transform = CGAffineTransform.identity
        
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.rotated(by: -CGFloat.pi)
            transform = transform.translatedBy(x: -width, y: -height)
        
        case .left, .leftMirrored:
            transform = transform.rotated(by: 0.5*CGFloat.pi)
            transform = transform.translatedBy(x: 0, y: -height)
            
        case .right, .rightMirrored:
            transform = transform.rotated(by: -0.5*CGFloat.pi)
            transform = transform.translatedBy(x: -width, y:0)
            
        case .up, .upMirrored:
            break
        }
        
        transform = transform.scaledBy(x: self.scale, y: self.scale)
        return transform
    }
    
    public func fixOrientation() -> UIImage? {
        
        guard let cgImage = self.cgImage else {
            return nil
        }
        
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        
        let width  = self.size.width
        let height = self.size.height
        
        var transform = CGAffineTransform.identity
        
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: width, y: height)
            transform = transform.rotated(by: CGFloat.pi)
            
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.rotated(by: 0.5*CGFloat.pi)
            
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: height)
            transform = transform.rotated(by: -0.5*CGFloat.pi)
            
        case .up, .upMirrored:
            break
        }
        
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            
        default:
            break;
        }
        
        guard let colorSpace = cgImage.colorSpace else {
            return nil
        }
        
        guard let context = CGContext(
            data: nil,
            width: Int(width),
            height: Int(height),
            bitsPerComponent: cgImage.bitsPerComponent,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: UInt32(cgImage.bitmapInfo.rawValue)
            ) else {
                return nil
        }
        
        context.concatenate(transform);
        
        switch self.imageOrientation {
            
        case .left, .leftMirrored, .right, .rightMirrored:
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: height, height: width))
        default:
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        }
        
        guard let newCGImg = context.makeImage() else {
            return nil
        }
        
        let img = UIImage(cgImage: newCGImg)
        
        return img;
    }
    
    public func screenResizedImage() -> UIImage {
        let xRatio = UIScreen.main.bounds.size.width * UIScreen.main.scale / (self.size.width * self.scale)
        let yRatio = UIScreen.main.bounds.size.height * UIScreen.main.scale / (self.size.height * self.scale)
        
        let scale = min(xRatio, yRatio)
        let size = CGSize( round(self.size.width * scale), round(self.size.height * scale))
        
        return self.resizeTo(size, with: .scaleAspectFill) ?? self
    }
    
    public func clipImage(at originYPercent: CGFloat, maxWidth: CGFloat) -> UIImage {
        var width = self.size.width
        var height = self.size.height
        if width > maxWidth {
            height = maxWidth / width * height
            width = maxWidth
        }
        
        let originY = height * originYPercent
        height -= originY
        if let sourceImageRef = self.cgImage, let newImageRef = sourceImageRef.cropping(to: CGRect(x: 0, y: originY * self.scale, width: width * self.scale, height: height * self.scale)) {
            return UIImage(cgImage: newImageRef, scale: self.scale, orientation: self.imageOrientation)
        }
        
        return self
    }
}


public extension UIImage {
    
    public func imageOfSize(_ size: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        self.draw(in: CGRect(0, 0, size.width, size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    public func imageOfWidthLessOrEqualTo(_ targetWidth: CGFloat) -> UIImage? {
        
        let imageWidth = self.size.width * self.scale
        
        if targetWidth < imageWidth {
            
            let scaleFactor = targetWidth / imageWidth
            
            let imageHeight = self.size.height * self.scale
            let scaleHeight = round(imageHeight * scaleFactor)
            
            let targetSize = CGSize(targetWidth, scaleHeight)
            let targetImage = self.imageOfSize(targetSize, scale: 1.0)
            
            return targetImage
        }
        
        return self
    }
    
    // size may be different
    public func imageOfBytesLessThanOrEqualTo(_ bytes: Int) -> UIImage? {
        
        // binary search on width
        var w:CGFloat = self.size.width
        
        if let image = imageOfSameSizeOfBytesLessThanOrEqualTo(bytes) {
            return image
        }
        
        while w > 1 {
            
            let hlf_w = w/2
            
            guard let image = imageOfWidthLessOrEqualTo(hlf_w) else {
                return nil
            }
            
            if let resultImage = image.imageOfSameSizeOfBytesLessThanOrEqualTo(bytes) {
                return resultImage
            }
            
            w = hlf_w
        }
        
        return nil
    }
    
    // keep size
    public func imageOfSameSizeOfBytesLessThanOrEqualTo(_ bytes: Int) -> UIImage? {
        
        if let data = self.jpegToData(quality: 0.1) {
            if data.count > bytes {
                return nil
            }
            // goto binary search
        } else {
            return nil
        }
        
        if let data = self.jpegToData(quality: 1) {
            if data.count < bytes {
                return self
            }
            // goto binary search
        } else {
            return nil
        }
        
        // 二分查找
        var s:Int = 1
        var e:Int = 10
        
        while s < e {
            
            let m = (s+e)/2
            
            guard let data = self.jpegToData(quality: CGFloat(m)/10) else {
                return nil
            }
            
            if data.count == bytes {
                return UIImage(data: data)
            }
            
            if data.count < bytes {
                s = m + 1
            } else {
                e = m - 1
            }
        }
        
        if let data = self.jpegToData(quality: CGFloat(min(s,e))/10) {
            return UIImage(data: data)
        }
        
        return nil
    }
    
    public func jpegToData(quality: CGFloat) -> Data? {
        if let data = self.jpegData(compressionQuality: quality) {
            return data
        }
        return nil
    }
    
    public class func generateQRCode(from string: String, expectedSize: CGSize) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            guard let image = filter.outputImage else {
                return nil
            }
            let size = image.extent.size
            guard size.width > 0, size.height > 0 else {
                return nil
            }
            let scaleX = expectedSize.width / size.width
            let scaleY = expectedSize.height / size.height
            let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            return UIImage(ciImage: image.transformed(by: transform))
        }
        return nil
    }

}
