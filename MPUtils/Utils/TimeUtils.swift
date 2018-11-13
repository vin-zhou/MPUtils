//
//  TimeUtils.swift
//
import Foundation

public let fullDateFormater = "yyyy年MM月dd日 HH:mm"
public let MdHmDateFormater = "MM月dd日 HH:mm"
public let MdDateFormater = "MM/dd"
public let dMDateFormater = "dd-MMMM"
public let MdCHNDateFormater = "M月d日"
public let YMDDateFormatter = "yyyy-MM-dd"
public let YMDDateFormatter2 = "yyyy年M月d日"
public let YMDDateFormatter3 = "yyyy.M.d"
public let YMDDateFormatter4 = "yyyy.MM.dd"
public let YMDDateTimeFormater = "yyyy-MM-dd HH:mm"
public let YMDDateTimeFormater2 = "yyyy.MM.dd HH:mm"
public let YMDDateTimeFormater3 = "MM.dd HH:mm"
public let YMDDateTimeFormater4 = "yyyy.MM.dd HH:mm:ss"
public let TodayFormater = "aah:mm"
public let ClockTime = "HH:mm"
public let ClockTimeA = "hh:mm a"
public let ClockSecTime = "HH:mm:ss"
public let WeekFormater = "EEEE"
public let dayFormater = "yy/M/d"
public let OneMinute = 60
public let OneHour = 60 * 60
public let OneDay = 24 * 60 * 60


// MARK: - transform
public class TimeUtils {
    
    fileprivate static var calendar = Calendar.current
    
    fileprivate static var iso8601DateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter
    }()
    
    public class func stringFromSeconds(_ seconds: Double, formatString: String, amSymbol: String? = nil, pmSymbol: String? = nil) -> String {
        if seconds <= 0 {
            return ""
        }
        let date = Date(timeIntervalSince1970: seconds)
        return stringFromDate(date, formatString: formatString, amSymbol: amSymbol, pmSymbol: pmSymbol)
    }
    
    public class func secondsFromString(_ string: String, formatString: String) -> Double {
        if let date = dateFromString(string, formatString: formatString) {
            return date.timeIntervalSince1970
        } else {
            return 0
        }
    }
    
    public class func dateFromISO8601DateString(_ string: String) -> Date? {
        if #available(iOS 10.0, *), let date = ISO8601DateFormatter().date(from: string) {
            return date
        } else {
            return iso8601DateFormatter.date(from: string)
        }
    }
    
    //date - string
    public class func dateFromString(_ string: String, formatString: String) -> Date? {
        let dateFormater = DateFormatter()
        dateFormater.timeZone = TimeZone.autoupdatingCurrent
        dateFormater.dateFormat = formatString
        return dateFormater.date(from: string)
    }
    
    public class func stringFromDate(_ date: Date, formatString: String, amSymbol: String? = nil, pmSymbol: String? = nil) -> String {
        let dateFormater = DateFormatter()
        dateFormater.timeZone = TimeZone.autoupdatingCurrent
        dateFormater.dateFormat = formatString
        if let amSymbol = amSymbol {
            dateFormater.amSymbol = amSymbol
        }
        if let pmSymbol = pmSymbol {
            dateFormater.pmSymbol = pmSymbol
        }
        return dateFormater.string(from: date)
    }
    
    public class func dateComponents(_ date: Date, unitFlags: NSCalendar.Unit) -> DateComponents {
        return (calendar as NSCalendar).components(unitFlags, from: date)
    }
    
    public class func dateFromComponents(_ comps: DateComponents) -> Date? {
        return calendar.date(from: comps)
    }
    
    public class func daysNumOfMonth(_ year: Int, month: Int) -> Int {
        switch month {
        case 1,3,5,7,8,10,12:
            return 31
        case 4,6,9,11:
            return 30
        default:
            break
        }
        if year % 4 == 1 || year % 4 == 2 || year % 4 == 3 {
            return 28
        }
        if year % 400 == 0 {
            return 29
        }
        
        if year % 100 == 0 {
            return 28
        }
        return 29
    }
}

//MARK: - comparision
extension TimeUtils {
    
    public class func isToday(_ date: Date) -> Bool{
        return isSameDay(date, second: Date(timeIntervalSinceNow: 0))
    }
    
    public class func isYesterday(_ date: Date) -> Bool{
        return isSameDay(date, second: Date(timeIntervalSinceNow: -60 * 60 * 24))
    }
    
    public class func isYesterdayAndBefore(_ date: Date) -> Bool {
        let date_ = date.addingTimeInterval(60*60*24)
        if isSameDay(Date(), second: date_) {
            return true
        }
        if date_.timeIntervalSince1970 < Date().timeIntervalSince1970 {
            return true
        }
        return false
    }
    
    public class func isSameYear(_ first: Date, second: Date) -> Bool{
        return isSame(first, second: second, compareUnit: [.era, .year])
    }
    
    public class func isSameMonth(_ first: Date, second: Date) -> Bool{
        return isSame(first, second: second, compareUnit: [.era, .year, .month])
    }
    
    public class func isSameDay(_ first: Date, second: Date) -> Bool{
        return isSame(first, second: second, compareUnit: [.era, .year, .month, .day])
    }
    
    public class func isSameHour(_ first: Date, second: Date) -> Bool{
        return isSame(first, second: second, compareUnit: [.era, .year, .month, .day, .hour])
    }
    
    public class func isSame(_ first: Date, second: Date, compareUnit: NSCalendar.Unit) -> Bool{
        
        var components = (calendar as NSCalendar).components(compareUnit, from: first)
        let dateOne = calendar.date(from: components)
        
        components = (calendar as NSCalendar).components(compareUnit, from: second)
        let dateTwo = calendar.date(from: components)
        
        if let one = dateOne, let two = dateTwo{
            return (one == two)
        }
        return false
    }
    
    public class func timeAgoFromSeconds(_ seconds: Double) -> String {
        
        let fromDate = Date(timeIntervalSince1970: seconds)
        let currDate = Date()
        
        let diff = currDate.timeIntervalSince(fromDate)
        
        let fromComp = (calendar as NSCalendar).components([.era, .year, .month, .day, .hour, .minute], from: fromDate)
        let currComp = (calendar as NSCalendar).components([.era, .year, .month, .day, .hour, .minute], from: currDate)
        
        if diff < 0 {
            return String(format: "%02d-%02d-%02d", fromComp.year!, fromComp.month!, fromComp.day!)
        }
        
        // 1分钟内
        if diff < 60 {
            return "刚刚"
        }
        
        // 1小时内
        if diff < 3600 {
            return "\(Int(diff/60))分钟前"
        }
        
        // 24小时内
        if diff < 3600*24 {
            // 跨两个自然日
            if isYesterday(fromDate) {
                // 大于6小时
                if diff > 3600 * 6 {
                    return "昨天"
                } else {
                    return "\(Int(diff/3600))小时前"
                }
            } else {
                if diff > 3600 * 6 {
                    return "\(Int(diff/3600))小时前"
                }
            }
            return "\(Int(diff/3600))小时前"
        }
       
        // 48小时内
        if diff < 3600*48 {
            // 两个自然日
            if isYesterday(fromDate) {
                return String(format: "昨天", fromComp.hour ?? 0, fromComp.minute ?? 0)
            }
        }
        
        // 跨年
        if fromComp.era != currComp.era || fromComp.year != currComp.year {
            return String(format: "%02d-%02d-%02d", fromComp.year ?? 0, fromComp.month ?? 0, fromComp.day ?? 0)
        }
        
        return String(format: "%02d-%02d", fromComp.month ?? 0, fromComp.day ?? 0)
    }
}
