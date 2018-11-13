//
//  Dictionary+.swift
//

import UIKit

public extension Dictionary {
    public mutating func replaceKey(_ originKey: Key, to newKey: Key) {
        if let value = self[originKey] {
            self.updateValue(value, forKey: newKey)
            self.removeValue(forKey: originKey)
        }
    }
}
