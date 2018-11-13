//
//  Array+.swift
//

import UIKit

public extension Array {
    public func safeObjectAtIndex(_ index:Int) -> Element? {
        if index < self.count {
            return self[index]
        }
        return nil
    }
    
    public func getRandomArray() -> Array<Element> {
        let arr = self.sorted { (a, b) -> Bool in
            let seed = arc4random_uniform(2)
            if seed == 0 {
                return true
            }
            else {
                return false
            }
        }
        return arr
    }
}
