//
//  Date+.swift
//

import UIKit

public extension Date {
    public var m_d: String {
        return TimeUtils.stringFromDate(self, formatString: "M-d")
    }
    
    public var hh_mm: String {
        return TimeUtils.stringFromDate(self, formatString: "HH:mm")
    }
    
    public var zeroHourDate: Date {
        let cal = Calendar.current
        let unitFlags = [Calendar.Component.year, Calendar.Component.month, Calendar.Component.day] as Set
        let day = cal.dateComponents(unitFlags, from: self)
        let format = "yyyy-MM-dd"
        let value = NSString(format: "%04i-%02i-%02i", day.year ?? 0, day.month ?? 0, day.day ?? 0)
        if let date = TimeUtils.dateFromString(value as String, formatString: format) {
            return date
        }
        return self
    }
}

public extension Date {
    public func differ(futureDate: Date) -> DateComponents {
        let date = DateFormatter()
        date.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let cal = Calendar.current
        let unitFlags = [Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second] as Set
        
        let d = cal.dateComponents(unitFlags, from: self, to: futureDate)
        
        return d
    }
}
