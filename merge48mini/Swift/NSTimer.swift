//
//  NSTimer 1.0
//  Created by Caleb Hess on 8/16/16.
//

import Foundation

class Timer {
    static func set(_ length: Double, target: AnyObject, selector: Selector) -> Foundation.Timer {
        return Foundation.Timer.scheduledTimer(timeInterval: length, target: target, selector: selector, userInfo: nil, repeats: false)
    }
    
    static func set(_ length: Double, target: AnyObject, selector: Selector, repeating: Bool) -> Foundation.Timer {
        return Foundation.Timer.scheduledTimer(timeInterval: length, target: target, selector: selector, userInfo: nil, repeats: repeating)
    }
}
