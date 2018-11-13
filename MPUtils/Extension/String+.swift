//
//  String+.swift
//
//  Created by XiaoshaQuan on 5/8/16.
//

import CommonCrypto

private let letters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

public let patternOfEmail : String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
public let patternOfPhone : String = "1[3|4|5|6|7|8|9|][0-9]{9}"
//少数名族，阿沛·阿旺晋美、卡尔·马克思
public let patternOfChinese: String = "[\\u4E00-\\u9FA5]{2,5}(?:·[\\u4E00-\\u9FA5]{2,5})*"
public let patternOfEnOrNumber: String = "^[a-zA-Z][0-9]+$"

public extension String {
    
    public var md5: String {
        
        let bytes = self.cString(using: String.Encoding.utf8)
        let bytesLength = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLength = Int(CC_MD5_DIGEST_LENGTH)
        let r = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLength)
        
        CC_MD5(bytes!, bytesLength, r)
        
        let str = NSString(format: "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15])
        
        r.deallocate()
        
        return str as String
    }
    
    public func stringByAppendingPathComponent(_ path: String) -> String {
        return (self as NSString).appendingPathComponent(path)
    }
    
    public func stringByAppendingUrlComponent(_ component: String) -> String {
        if self.last == "/" {
            return self + component
        } else {
            return self + "/\(component)"
        }
    }
    
    public var length: Int {
        return self.count
    }
    
    public subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    public subscript (i: Int) -> String {
        return String(self[i] as Character)
    }

    public static func randomStringWithLength(_ length: Int) -> String {
        
        let randomString = NSMutableString(capacity: length)
        
        for _ in 0..<length {
            let pos: Int = Int(arc4random_uniform(UInt32(letters.length)))
            randomString.appendFormat("%C", letters.character(at: pos))
        }
        
        return randomString as String
    }
}



public extension String {
    
    public var trim : String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    public var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    
    public var urlEncodingString: String? {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]").inverted)
    }
    
    public func isChinese() -> Bool {
        let predicate = NSPredicate(format: "SELF matches %@", patternOfChinese)
        return predicate.evaluate(with: self)
    }
    
    public func isEnOrNumber() -> Bool {
        let characterSet = CharacterSet(charactersIn: "0123456789abcdefghijklmnopqrstvuwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        let scan =  Scanner(string: self)
        var testString: NSString?
        scan.scanCharacters(from: characterSet, into: &testString)
        return (self == (testString as String?)) && scan.isAtEnd
    }
    
    public func isNumber() -> Bool {
        let scan =  Scanner(string: self)
        var val = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }
    
    public func isIdCard() -> Bool {
        if self.count != 18 {
            return false
        }
        // 正则表达式判断基本 身份证号是否满足格式
        let regex2: String = "^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$"
        let identityStringPredicate = NSPredicate(format: "SELF MATCHES %@", regex2)
        //如果通过该验证，说明身份证格式正确，但准确性还需计算
        if !identityStringPredicate.evaluate(with: self) {
            return false
        }
        //** 开始进行校验 *//
        //将前17位加权因子保存在数组里
        var idCardWiArray: [Int] = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2]
        //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        var idCardYArray: [Int] = [1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2]
        
        var idCardWiSum: Int = 0
        for i in 0..<17 {
            let subStrIndex = self.substring(with: self.index(self.startIndex, offsetBy: i) ..< self.index(self.startIndex, offsetBy: i+1))
            let idCardWiIndex = idCardWiArray[i]
            idCardWiSum += Int(subStrIndex)! * idCardWiIndex
        }
        //计算出校验码所在数组的位置
        let idCardMod: Int = idCardWiSum % 11
        //得到最后一位身份证号码
        let idCardLast: String = (self as NSString).substring(with: NSRange(location: 17, length: 1))
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if idCardMod == 2 {
            if idCardLast.lowercased() != "x" {
                return false
            }
        }
        else {
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if Int(idCardLast) != idCardYArray[idCardMod] {
                return false
            }
        }
        return true
    }
    
    public func isMatchingRegularExpression(_ pattern: String) -> Bool {
        
        if self.isEmpty || pattern.isEmpty {
            return false
        }
        
        do {
            let expression = try NSRegularExpression(pattern: pattern, options:[])
            let range = expression.rangeOfFirstMatch(in: self, options: [], range: NSMakeRange(0, self.length))
            
            if (range.location == 0) && (range.length == self.length) {
                return true
            }
            
            return false
        }
        catch {
            return false
        }
    }
    
    public func isMatchingRegular(_ regular: String) -> Bool {
        if self.isEmpty || regular.isEmpty {
            return false
        }
        let test: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regular)
        return test.evaluate(with: self)
    }
    
    public func takeOffSensitiveWordWithSfz() -> String {
        if self.count < 18 {
            return self
        }
        
        let prefix = self.captureSubString(to: 4)
        let suffix = self.substring(with: self.index(self.endIndex, offsetBy: -4)..<self.endIndex)
        return "\(prefix)**********\(suffix)"
    }
    
    public func matchPhoneNumbers() -> [(String, NSRange)]? {
        let types: UInt64 = NSTextCheckingResult.CheckingType.phoneNumber.rawValue
        guard let detector: NSDataDetector = try? NSDataDetector(types: types) else {
            return nil
        }
        
        let matches: [NSTextCheckingResult] = detector.matches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: self.length))
        let results: [(String, NSRange)] = matches.compactMap { (result) -> (String, NSRange)? in
            if result.resultType == .phoneNumber, let phone = result.phoneNumber {
                return (phone, result.range)
            }
            
            return nil
        }
        
        return results
        
    }
    
    public func labelHeight(_ width: CGFloat, font: UIFont) -> CGFloat {
        let label = UILabel()
        label.font = font
        label.text = self
        label.width = width
        label.numberOfLines = 0
        label.sizeToFit()
        return label.height
    }
    
    public func labelHeight(_ width: CGFloat, font: UIFont, linesapce: CGFloat) -> CGFloat {
        let label = UILabel()
        label.font = font
        label.text = self
        label.width = width
        label.numberOfLines = 0
        
        let attr = NSMutableAttributedString.init(string: self)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = linesapce
        attr.addAttributes([NSAttributedString.Key.paragraphStyle:style], range: NSMakeRange(0, self.length))
        label.attributedText = attr
        
        label.sizeToFit()
        return label.height
    }
    
    public func appendEllipsisFrom(_ index: Int) -> String {
        
        guard self.length > index else {
            return self
        }
        
        let subString = self.captureSubString(to: index)
        return "\(subString)..."
    }
    
    // [index, length - 1]
    public func captureSubString(from index: Int) -> String {
        return self.captureSubString(from: index, to: length - 1)
    }
    
    // [0, index]
    public func captureSubString(to index: Int) -> String {
        return self.captureSubString(from: 0, to: index)
    }
    
    // [from, to]
    public func captureSubString(from: Int, to: Int) -> String {
        guard from >= 0, to >= from, to < self.length else {
            return self
        }
        
        let start = self.index(self.startIndex, offsetBy: from)
        let end = self.index(self.startIndex, offsetBy: to)
        return String(self[start...end])
    }
    
    public func filterNumbers() -> String {
        let digitSet = CharacterSet.decimalDigits
        return String(self.unicodeScalars.filter { digitSet.contains($0) })
    }
    
    public func hasEmoji() -> Bool {
        let pattern = "[\\ud83c\\udc00-\\ud83c\\udfff]|[\\ud83d\\udc00-\\ud83d\\udfff]|[\\u2600-\\u27ff]"
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        var hasEmoji = false
        if let matches = regex?.matches(in: self, options: [], range: NSMakeRange(0,self.length)) {
            hasEmoji = matches.count > 0
        }
        return hasEmoji
    }
    
    public func getLeftLength(_ maxChinese: Int) -> Int {
        //获取剩余可以输入的字符数量（按汉字为单位）
        return maxChinese - self.meipuByteLength/2 - self.meipuByteLength%2
    }
    
    public func widthWithFont(_ font: UIFont) -> CGFloat {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font: font]).width
    }
    
    public func stringLimitedToWidth(_ width: CGFloat, withFont font: UIFont, withTruncationTailToken token: String? = "...") -> String {
        
        var tailToken = ""
        if let token = token {
            tailToken = token
        }
        
        if widthWithFont(font) < width {
            return self
        }
        
        // 二分查找
        var s:Int = 0
        var e:Int = self.length - 1
        while s+1 < e {
            
            let m = (s+e)/2
            
            let subStr = String(self[..<self.index(self.startIndex, offsetBy: m)]) + tailToken
            let subStrWidth = subStr.widthWithFont(font)
            
            // exit condition
            if abs(subStrWidth - width) < LENGTH_EPSILON {
                // consider equal
                return subStr
            }
            
            if subStrWidth < width {
                s = m + 1
            } else {
                e = m - 1
            }
        }
        // 上面只是找到<width的位置，还需要进一步确定最长的那个
        while s + 1 < self.length {
            let subStr = (self as NSString).substring(to: s + 1) + tailToken
            let subStrWidth = subStr.widthWithFont(font)
            if subStrWidth <= width {
                s = s + 1
            } else {
                break
            }
        }
        
        return "\((self as NSString).substring(to: s))\(tailToken)"
    }
    
    public func appendEllipsisFromByte(_ length: Int) -> String {
        
        guard self.meipuByteLength > length else {
            return self
        }
        
        let subString = self.stringLimitedToBytes(length)
        return "\(subString)..."
    }
    
    public func stringLimitedToBytes(_ bytes: Int, withTruncationTailToken token: String? = nil) -> String {
        var curBytes: Int = 0
        var i = 0
        var needAddTruncationTail = false
        while i < self.count {
            
            let str: String = self[i]
            
            curBytes += str.meipuByteLength
            
            if curBytes > bytes {
                needAddTruncationTail = true
                break
            }
            
            i += 1
        }
        return self.captureSubString(to: i) + (needAddTruncationTail ? (token ?? "") : "")
    }
    
    public func getAgeByBirthday(_ nowDate: Date = Date()) -> Int {
        //birth = yyyy-MM-dd
        if let birthDate = TimeUtils.dateFromString(self, formatString: YMDDateFormatter) {
            let birthComponents = Calendar.current.dateComponents([.year,.month,.day], from: birthDate)

            let nowComponents = Calendar.current.dateComponents([.year,.month,.day], from: nowDate)
            
            guard let nowYear = nowComponents.year, let nowMonth = nowComponents.month, let nowDay = nowComponents.day, let birthYear = birthComponents.year, let birthMonth = birthComponents.month, let birthDay = birthComponents.day else {
                return 0
            }
            
            var yearsOld = nowYear - birthYear - 1
            if nowMonth > birthMonth {
                yearsOld += 1
            } else if nowMonth == birthMonth, nowDay >= birthDay {
                yearsOld += 1
            }
            
            return yearsOld
        }
        return 0
    }
}

//表情处理，因iOS中计算带表情的高度无法计算正确，所以需要自行根本表情反悔处理需要加的px值
// MARK: - 可能出现表情的地方主动处理
public extension String {
    public func divergeHeightByEmoji(_ width: CGFloat, font: UIFont, numberOfLines: Int = 0) -> CGFloat {
        if !self.hasEmoji() {
            return 0
        }
        let emojiDevergeHeight : CGFloat = 3
        let size = UILabel.labelSize(CGFloat(MAXFLOAT), font: font, text: self)
        if size.width < width {
            //总长度小与width，返回一个偏移
            return emojiDevergeHeight
        }
        //否则，遍历字符计算
        var allDeverge : CGFloat = 0
        for index in 0..<self.length {
            let char = String(self[self.index(self.startIndex, offsetBy: index)..<self.index(self.startIndex, offsetBy: index+1)])
            if char.hasEmoji() {
                let text = String(self[..<self.index(self.startIndex, offsetBy: index+1)])
                let size = UILabel.labelSize(CGFloat(MAXFLOAT), font: font, text: text)
                let line = Int(size.width / width) + 1
                if numberOfLines > 0 && line > numberOfLines {
                    //已超过最多行数，结束遍历
                    break
                }
                if CGFloat(line) * emojiDevergeHeight > allDeverge {
                    allDeverge += emojiDevergeHeight
                }
            }
        }
        return allDeverge
    }
    
    public func problemReplacement() -> String {
        let str = self
        //        if str.contains("痘痘") && !str.contains("痘痘/痘印"){
        //            str = str.replacingOccurrences(of: "痘痘", with: "痘痘/痘印")
        //        }
        //        if str.contains("皱纹") && !str.contains("眼部皱纹"){
        //            str = str.replacingOccurrences(of: "皱纹", with: "眼部皱纹")
        //        }
        return str
    }
    
    public func nsrange(of string: String) -> NSRange {
        guard !string.isEmpty else {
            return NSMakeRange(NSNotFound, NSNotFound)
        }
        
        guard let range = self.range(of: string) else {
            return NSMakeRange(NSNotFound, NSNotFound)
        }
        
        let location = self.distance(from: self.startIndex, to: range.lowerBound)
        let length = self.distance(from: range.lowerBound, to: range.upperBound)
        return NSMakeRange(location, length)
    }
    
    // 如果text加上replaceString大于指定maxLineNumber，则截取并添加"..."至末尾。replaceString可用于设置最后一行"..."至行尾的预留宽度。
    public func ellipsisFitText(width: CGFloat, maxLineNumber: Int, replaceString: String, font: UIFont) -> String {
        
        var numberOfCharas = NSNotFound
        let originText = self
        let textWithReplaceString = replaceString + originText
        for i in 1 ... textWithReplaceString.length {
            let subStr = textWithReplaceString.captureSubString(to: i - 1)
            if UILabel.lineCount(width, font: font, text: subStr) > maxLineNumber {
                numberOfCharas = i - 1
                break
            }
        }
        
        if  numberOfCharas != NSNotFound{
            
            var i = numberOfCharas - 1
            while i > 0 {
                var subStr = textWithReplaceString.captureSubString(to: i - 1)
                subStr += "..."
                if UILabel.lineCount(width, font: font, text: subStr) <= maxLineNumber {
                    numberOfCharas = i
                    break
                }
                i -= 1
            }
            return textWithReplaceString.captureSubString(from: replaceString.length, to: numberOfCharas - 1) + "..."
        }
        
        return originText
    }
}

public extension String {
    
    // 汉子、表情为2个字节，英文为1个字节
    public var meipuByteLength: Int {
        
        var bytes : Int = 0
        
        for c in self {
            let char = String(c)
            if char.hasEmoji() {
                if let value = char.unicodeScalars.first?.value {
                    if value > 0xffff {
                        bytes += 4
                    } else {
                        bytes += 3
                    }
                } else {
                    bytes += 4
                }
            } else {
                bytes += (char.utf8.count + 1) / 2
            }
        }
        return bytes
    }
    
    public var isSingleNumber: Bool {
        if self.count == 1 {
            let char = self.first!
            return char >= "0" && char <= "9"
        }
        return false
    }
    
    public var isAllNumber: Bool {
        let count = self.reduce(0) { (r, char) -> Int in
            if char >= "0" && char <= "9" {
                return r
            } else {
                return r + 1
            }
        }
        return count == 0
    }
    
    public var isChineseCharacter: Bool {
        if self.count == 1 {
            let char = self.first!
            return char >= "\u{4e00}" && char <= "\u{9FA5}"
        }
        return false
    }
    
    public func trimmingWhiteSpacePrefix() -> String {
        var offset = 0
        while offset < self.count {
            if self[self.index(self.startIndex, offsetBy: offset)] == " " {
                offset += 1
            } else {
                break
            }
        }
        return self.captureSubString(from: offset)
    }
    
    
    public var isAllWhiteSpace: Bool {
        for char in self {
            if char != " " {
                return false
            }
        }
        return true
    }
}

public extension String {
    
    public var toURL: URL? {
        let url = self.trim
        guard !StringUtils.isEmpty(url) else {
            return nil
        }
        return URL(string: url)
    }
    
    public var isInnerUrl: Bool {
        return self.isMatchingRegularExpression("http(s?)://([^/]+[.])*(meipu.cn|meipuapp.hk|meipuapp.com)(/([^/]+))*[/]?")
    }
    
    public var isMtmzSchemaUrl: Bool {
        return self.isMatchingRegularExpression("meitumeipu://([^/]+[.])*(meipu.cn|meipuapp.hk|meipuapp.com)(/([^/]+))*[/]?")
    }
    
    public var isHttpUrl: Bool {
        let lowercaseString = self.lowercased()
        return lowercaseString.hasPrefix("http://") || lowercaseString.hasPrefix("https://")
    }
    
    public var allImageUrls : [String]? {
        let regulaStr = "(<img src=\"(https|http)?:\\/\\/)[^\\s]+"
        let regex = try? NSRegularExpression(pattern: regulaStr, options: .caseInsensitive)
        let arrayOfAllMatches = regex?.matches(in: self, options: [], range: NSRange(location: 0, length: self.length))
        
        return arrayOfAllMatches?.map { (match) -> String in
            let img: String = (self as NSString).substring(with: match.range)
            return img.replacingOccurrences(of: "<img src=\"", with: "").replacingOccurrences(of: "\"", with: "")
        }
    }
    
    public var urlParameters: [String: Any]? {
        
        let urlComponents = self.components(separatedBy: CharacterSet(charactersIn: "?"))
        
        guard urlComponents.count > 1 else {
            return nil
        }
        
        var ret: [String: Any] = [:]
        
        let parameters = urlComponents[1].components(separatedBy: CharacterSet(charactersIn: "&"))
        
        for parameter in parameters {
            let comps = parameter.components(separatedBy: CharacterSet(charactersIn: "="))
            if comps.count == 2 {
                ret[comps[0]] = comps[1]
            }
        }
        return ret
    }
    
}
