//
//  StopWatch.swift
//  March 20, 2017
//  Caleb Hess
//
//  toolkit-swift
//

import Foundation

public class StopWatch {
    var timeStart = CFAbsoluteTimeGetCurrent()
    var timeElapsed = CFAbsoluteTimeGetCurrent()
    var sum = 0.0
    
    func start() {
        sum = 0.0
        timeStart = CFAbsoluteTimeGetCurrent()
    }
    
    @discardableResult func stop() -> Double {
        timeElapsed = CFAbsoluteTimeGetCurrent() - timeStart
        sum += timeElapsed
        timeStart = CFAbsoluteTimeGetCurrent()
        return timeElapsed
    }
    
    func statistics() {
        let ms = Int(round(timeElapsed * 1000.0))
        print("time elapsed: " + String(ms) + " ms")
    }
}
