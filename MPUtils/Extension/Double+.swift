//
//  Double+.swift
//

import Foundation

public extension Double {
    //  需求：保留两位小数，若最后一位小数为0，则去掉0；若两位都是0，则取整数
    //  1.若设置好精度后，直接输出double，那么会至少保留1位小数，例：90.00 -> 90.0
    //  2.若设置好精度后，直接输出NSNumber，那么会符合我们的需求，但是会存在精度问题，例：0.07 -> 0.070000000000001
    //  所以此处实现适用方式1+CutSuffix
    
    public func mp￥Price(_ adjustRule: Bool = false) -> String {
        let result : String = self.mpPrice(adjustRule)
        return "¥\(result)"
    }
    
    public func mpPrice(_ adjustRule: Bool = false) -> String {
        if adjustRule {
            return mpString()
        } else {
            let result = String(format: "%.2f", self)
            if let price : Double = Double(result) {
                return price.CutSuffix()
            } else {
                return result
            }
        }
    }
   
    public func mp￥Price2() -> String{
        return String(format: "¥%.2f", self)
    }
    
    public func mpPrice2() -> String{
        return String(format: "%.2f", self)
    }

    private func mpString() -> String {
        if self >= 10000 {
            return Int(floor(self)).mpNumber()
        } else {
            let result : String = String(format: "%.2f", self)
            if let price : Double = Double(result) {
                return price.CutSuffix()
            }
        }
        return "0"
    }
    
    public func CutSuffix() -> String {
        var numberString = "\(self)"
        if numberString.hasSuffix(".0") {
            numberString.removeSubrange(numberString.index(numberString.endIndex, offsetBy: -2)..<numberString.endIndex)
        }
        return numberString
    }
}

public extension Double {
    
    public func mpLongString() -> String {
        return "\(NSNumber(value: self as Double))"
    }
    
    public func mpTimeStringBySecond() -> String {
        return Double.getFormatTime(self)
    }
    
    public func mpTimeStringByMilsecond() -> String {
        return Double.getFormatTime(self/1000.0)
    }
    
    public func mpDateStringByMilsecond(_ format: String = "yyyy-MM-dd") -> String {
        return Double.getFormatTime(self/1000.0, format: format)
    }
    
    fileprivate static func getFormatTime(_ t: TimeInterval, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dfmatter = DateFormatter()
        dfmatter.dateFormat =  format
        let date = Date(timeIntervalSince1970:t)
        let dateStamp = dfmatter.string(from: date)
        return dateStamp
    }
}

public extension Double {
    
    public func getShowTimeDesc() -> String {
        let time = self / 1000
        var dateFormat = "yyyy-MM-dd"
        if isSameYear(Date(timeIntervalSince1970:time), day2: Date()) {
            dateFormat = "MM-dd"
        }
       return mpDateStringByMilsecond(dateFormat)
    }
    
    fileprivate func isSameYear(_ day1: Date, day2: Date) -> Bool {
        let calendar = Calendar.current
        let comp1: DateComponents = (calendar as NSCalendar).components([.year,.month,.day], from: day1)
        let comp2: DateComponents = (calendar as NSCalendar).components([.year,.month,.day], from: day2)
        return comp1.year == comp2.year
    }
}

public extension Double {
    public static func multiplyingAccurately(ls: String, rs: String, scale: UInt) -> String {
        let leftNumber = NSDecimalNumber(string: ls)
        let rightNumber = NSDecimalNumber(string: rs)
        let resultNumber = leftNumber.multiplying(by: rightNumber)
        
        let behavior = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.plain, scale: Int16(scale), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
        let roundedNumber = resultNumber.rounding(accordingToBehavior: behavior)
        var result = roundedNumber.stringValue
        if scale > 0 {
            if !result.contains(".") {
                result.append(".")
            }
            
            let split = result.components(separatedBy: ".")
            let dotCount = split[1].length
            if dotCount < scale {
                for _ in 0..<(scale - UInt(dotCount)) {
                    result.append("0")
                }
            }
            
        }
        return result
    }
}
