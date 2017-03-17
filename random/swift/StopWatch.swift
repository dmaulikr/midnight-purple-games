//
//  StopWatch 1.0
//  Created by Caleb Hess on 2/22/16.
//

import Foundation

public class StopWatch {
    var timeStart = CFAbsoluteTimeGetCurrent()
    var timeElapsed = CFAbsoluteTimeGetCurrent()
    var sum = 0.0
    
    public func start() {
        sum = 0.0
        timeStart = CFAbsoluteTimeGetCurrent()
    }
    
    public func stop() -> Double {
        timeElapsed = CFAbsoluteTimeGetCurrent() - timeStart
        sum += timeElapsed
        timeStart = CFAbsoluteTimeGetCurrent()
        return timeElapsed
    }
    
    public func statistics() {
        let ms = Int(round(timeElapsed * 1000.0))
        print("time elapsed: \(ms) ms")
    }
}
