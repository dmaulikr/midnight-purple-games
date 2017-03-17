//
//  NSTimer 1.0
//  Created by Caleb Hess on 6/25/16.
//

class Timer {
    static func set(length: Double, target: AnyObject, selector: Selector) -> NSTimer {
        return NSTimer.scheduledTimerWithTimeInterval(length, target: target, selector: selector, userInfo: nil, repeats: false)
    }
    
    static func set(length: Double, target: AnyObject, selector: Selector, repeating: Bool) -> NSTimer {
        return NSTimer.scheduledTimerWithTimeInterval(length, target: target, selector: selector, userInfo: nil, repeats: repeating)
    }
}
