//
//  GCDUtils.swift
//

import Foundation


public final class GCDUtils {
    
    public class func main(syncable: Bool = false, _ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            if syncable {
                DispatchQueue.main.sync(execute: block)
            } else {
                DispatchQueue.main.async(execute: block)
            }
        }
    }
    
    public class func sync(_ queue: DispatchQueue = DispatchQueue.main, block: () -> Void) {
        queue.sync {
            block()
        }
    }
    
    public class func async(_ queue: DispatchQueue = DispatchQueue.main, block: @escaping () -> Void) {
        queue.async {
            block()
        }
    }
    
    public class func asyncBackground(_ block: @escaping () -> Void) {
        async(DispatchQueue.global(qos: .background), block: block)
    }
    
    public class func delay(_ seconds: TimeInterval, queue: DispatchQueue = DispatchQueue.main, block: @escaping () -> Void) {
        queue.asyncAfter(deadline: DispatchTime.now() + seconds) { () -> Void in
            block()
        }
    }
    /*
     Handle each element in the array concurrently, then group them in the complete closure in main thread.
     @param array: a array of elements
     @param handle: @escaping (index: Int, completion: @escaping (Bool) -> Void) -> Void
     handle the element for the index of the array; completion callback after the element handled
     @param completion: callback after all the elements handled
     */
    public class func asyncGroup<T>(array: [T], handle: @escaping (Int, @escaping (Bool) -> Void) -> Void, completion: @escaping((Bool) -> Void)) {
        
        let group = DispatchGroup()
        let queue = DispatchQueue.global()
        var results: [Bool] = Array(repeating: false, count: array.count)
        
        for i in 0 ..< array.count {
            group.enter()
            queue.async(group: group) {
                handle(i) { result in
                    DispatchQueue.main.async {
                        results[i] = result
                        group.leave()
                    }
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            let success = results.reduce(true, {$0 && $1})
            completion(success)
        }
    }
}

