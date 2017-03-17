//
//  StopWatch 1.0
//  Created by Caleb Hess on 8/16/16.
//

import Foundation

open class StopWatch {
    var timeStart = CFAbsoluteTimeGetCurrent()
    var timeElapsed = CFAbsoluteTimeGetCurrent()
    var sum = 0.0
    
    open func start() {
        sum = 0.0
        timeStart = CFAbsoluteTimeGetCurrent()
    }
    
    open func stop() -> Double {
        timeElapsed = CFAbsoluteTimeGetCurrent() - timeStart
        sum += timeElapsed
        timeStart = CFAbsoluteTimeGetCurrent()
        return timeElapsed
    }
    
    open func statistics() {
        let ms = Int(round(timeElapsed * 1000.0))
        print("time elapsed: \(ms) ms")
    }
}
