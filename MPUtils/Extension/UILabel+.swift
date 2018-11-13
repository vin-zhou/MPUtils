//
//  UILabel+.swift
//

import Foundation

public extension UILabel {
    public class func labelHeight(_ width: CGFloat, font: UIFont, text: String, numberOfLines: Int = 0) -> CGFloat {
        let size = self.labelSize(width, font: font, text: text, numberOfLines: numberOfLines)
        return size.height
    }
    
    public class func labelSize(_ width: CGFloat, font: UIFont, text: String, numberOfLines: Int = 0) -> CGSize {
        let label = UILabel()
        label.font = font
        label.numberOfLines = numberOfLines
        label.text = text

        let size = label.sizeThatFits(CGSize(width: width, height: 0))
        return size
    }
    
    @objc public func labelSize(_ width: CGFloat) -> CGSize {
        let label = UILabel()
        label.font = self.font
        label.numberOfLines = 0
        label.text = self.text
        let size = label.sizeThatFits(CGSize(width: width, height: 0))
        return size
    }
    
    public func adjustFitText() -> String {
        
        var numberOfCharas = NSNotFound
        guard let text = self.text else {
            return ""
        }
        
        for i in 0...text.length {
            let subStr = text.captureSubString(to: i)
            let attributedText = NSAttributedString(string: subStr, attributes: [NSAttributedString.Key.font: self.font])
            let size = CGSize(width: self.frame.size.width, height: self.frame.size.height)
            let textFrame = attributedText.boundingRect(with: size, options:NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
            if (textFrame.width + 1.0 * CGFloat(i)) >= self.frame.width {
                numberOfCharas = i
                break;
            }
        }
        
        if  numberOfCharas != NSNotFound{
            return text.captureSubString(to: numberOfCharas)
        }
        
        return text
    }
    


    public class func lineCount(_ width: CGFloat, font: UIFont, text: String) -> NSInteger {
        let label = UILabel()
        label.font = font
        label.text = text
        label.numberOfLines = 0
        let labelHeight = label.sizeThatFits(CGSize(width: width, height: 0)).height
        let count = labelHeight / label.font.lineHeight
        return Int(count)
    }
    
    /*
     *  消息模块的文本内容截取
     *
     *  文本格式:  赞了 + " + 内容 + ”
     *  截取规则:  若文本长度可显示区域长度, 则截取超出部分，变为... （赞了 + " + 截取内容 + ... + "）
     */
    public func messageAdjustFitText() -> String {
        
        var numberOfCharas = NSNotFound
        guard let text = self.text else {
            return ""
        }
        
        for i in 1...text.length {
            let subStr = text.captureSubString(to: i)
            let attributedText = NSAttributedString(string: subStr, attributes: [NSAttributedString.Key.font: self.font])
            let size = CGSize(width: self.frame.size.width, height: self.frame.size.height)
            let textFrame = attributedText.boundingRect(with: size, options:[], context: nil)
            if (textFrame.width + 1.0 * CGFloat(i)) >= self.frame.width {
                
                numberOfCharas = i
                break;
            }
        }
        
        if  numberOfCharas != NSNotFound {
            return text.captureSubString(to: numberOfCharas - 1) + "...\""

        }
        
        return text

    }
    
    // 如果text大于指定maxLineNumber，则截取并添加"..."至末尾。replaceString可用于设置最后一行"..."至行尾的预留宽度。
    public func ellipsisFitText(width: CGFloat, maxLineNumber: Int, replaceString: String) -> String {
        
        var numberOfCharas = NSNotFound
        guard (self.text != nil) else {
            return ""
        }
        let originText = self.text!
        for i in 1 ... originText.length {
            let subStr = originText.captureSubString(to: i - 1)
            if UILabel.lineCount(width, font: font, text: subStr) > maxLineNumber {
                numberOfCharas = i - 1
                break
            }
        }
        
        if  numberOfCharas != NSNotFound{
            
            var i = numberOfCharas - 1
            while i > 0 {
                var subStr = originText.captureSubString(to: i - 1)
                subStr += replaceString + "..."
                if UILabel.lineCount(width, font: font, text: subStr) <= maxLineNumber {
                    numberOfCharas = i
                    break
                }
                i -= 1
            }
            return originText.captureSubString(to: numberOfCharas - 1) + "..."
        }
        
        return originText
    }
}


