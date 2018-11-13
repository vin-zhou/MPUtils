//
//  MiscUtils.swift
//

import Foundation

// length smaller than this value will be considered as zero.
public let LENGTH_EPSILON: CGFloat = 0.00001

public let TIME_EPSILON_MS: Double = 0.0000000001

public let ScreenWidth  = UIScreen.main.bounds.size.width
public let ScreenHeight = UIScreen.main.bounds.size.height
public let ScreenScale  = UIScreen.main.scale

public let iOS9AndAbove: Bool = {
    if #available(iOS 9.0, *) {
        return true
    } else {
        return false
    }
}()

public let iPhone6AndAbove: Bool = {
    if ScreenWidth > 320 {
        return true
    } else {
        return false
    }
}()

@available(*, deprecated: 1.0.0, message: "Fix me")
public func FIXME() { }


public func isZeroFloat(_ f: CGFloat) -> Bool {
    return abs(f) < LENGTH_EPSILON
}

public func widthFitScreen(_ width: CGFloat) -> CGFloat {
    return ScreenWidth / 375.0 * width
}

public func heightFitScreen(_ height: CGFloat) -> CGFloat {
    return ScreenWidth / 375.0 * height
}

