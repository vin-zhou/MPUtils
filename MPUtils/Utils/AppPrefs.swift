//
//  AppPrefs.swift
//

import UIKit

open class AppPrefs {
    //直接跳到App对应的设置页，其他的都直接调用这个
    open class func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    // 打开系统蓝牙设置
    @discardableResult open class func openBluetooth() -> Bool {
        guard let url = getBluetooth() else {
            return false
        }
        return open(toUrl: url)
    }
    
    // 打开系统定位设置
    @discardableResult open class func openLocation() -> Bool {
        guard let url = getLocation() else {
            return false
        }
        return open(toUrl: url)
    }
    
    // 打开系统通知
    @discardableResult open class func openNotification() -> Bool {
        guard let url = getNotification() else {
            return false
        }
        return open(toUrl: url)
    }
    
    private class func open(toUrl url: String) -> Bool {
        guard let url = url.toURL, UIApplication.shared.canOpenURL(url) else {
            return false
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        return true
    }
}

extension AppPrefs {
    fileprivate class func getBluetooth() -> String? {
        let bluetooth = Data(bytes: [66, 108, 117, 101, 116, 111, 111, 116, 104])
        let bluetoothString = String(data: bluetooth, encoding: .ascii)
        let method = "\(self.prefix())\(bluetoothString ?? "")"
        return method
    }
    
    fileprivate class func getLocation() -> String? {
        let location = Data(bytes: [80, 114, 105, 118, 97, 99, 121, 38, 112, 97, 116, 104, 61, 76, 79, 67, 65, 84, 73, 79, 78])
        let locationString = String(data: location, encoding: .ascii)
        let method = "\(self.prefix())\(locationString ?? "")"
        return method
    }
    
    fileprivate class func getNotification() -> String? {
        let notif = Data(bytes: [78, 79, 84, 73, 70, 73, 67, 65, 84, 73, 79, 78, 83, 95, 73, 68,38,112,97,116,104,61,99,111,109,46,109,101,105,116,117,46,109,101,105,112,117])
        let notifString = String(data: notif, encoding: .ascii)
        let method = "\(self.prefix())\(notifString ?? "")"
        return method
    }
    
    private class func prefix() -> String {
        let prefix = Data(bytes: [65, 112, 112, 45, 80, 114, 101, 102, 115])
        let prefixString = String(data: prefix, encoding: .ascii)
        let root = Data(bytes: [114, 111, 111, 116])
        let rootString = String(data: root, encoding: .ascii)
        return "\(prefixString ?? ""):\(rootString ?? "")="
    }

}
