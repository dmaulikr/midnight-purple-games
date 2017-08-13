//
//  EasyTimer.swift
//  March 20, 2017
//  Caleb Hess
//
//  toolkit-swift
//

import Foundation

public class EasyTimer {
    var timer: Timer!
    var target: AnyObject!
    
    init(_ target: AnyObject) {
        self.target = target
    }
    
    func set(_ seconds: Double, selector: Selector, repeating: Bool = false) {
        timer = Foundation.Timer.scheduledTimer(timeInterval: seconds, target: target, selector: selector, userInfo: nil, repeats: repeating)
    }
    
    func clear() {
        timer.invalidate()
        timer = nil
    }
}
