//
//  Timer.swift
//  Paid to Go
//
//  Created by Nahuel on 27/6/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation

protocol TimerDelegate {
    func timerWillStart(timer : CustomTimer)
    func timerDidFire(timer : CustomTimer)
    func timerDidPause(timer : CustomTimer)
    func timerWillResume(timer : CustomTimer)
    func timerDidStop(timer : CustomTimer)
}

class CustomTimer : NSObject {
    
    var timer : Timer!
    var interval : TimeInterval
    var difference : TimeInterval = 0.0
    var delegate : TimerDelegate?
    
    init(interval: TimeInterval, delegate: TimerDelegate?)
    {
        self.interval = interval
        self.delegate = delegate
    }
    
    @objc func start(aTimer : Timer?)
    {
        if aTimer != nil { fire() }
        if timer == nil {
            delegate?.timerWillStart(timer: self)
            timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(Timer.fire), userInfo: nil, repeats: true)
        }
    }
    
    func pause()
    {
        if timer != nil {
            difference = timer.fireDate.timeIntervalSince(Date())
            timer.invalidate()
            timer = nil
            delegate?.timerDidPause(timer: self)
        }
    }
    
    func resume()
    {
        if timer == nil {
            delegate?.timerWillResume(timer: self)
            if difference == 0.0 {
                start(aTimer: nil)
            } else {
                Timer.scheduledTimer(timeInterval: difference, target: self, selector: #selector(CustomTimer.start(aTimer:)), userInfo: nil, repeats: false)
                difference = 0.0
            }
        }
    }
    
    func stop()
    {
        if timer != nil {
            difference = 0.0
            timer.invalidate()
            timer = nil
            delegate?.timerDidStop(timer: self)
        }
    }
    
    func fire()
    {
        delegate?.timerDidFire(timer: self)
    }
}
