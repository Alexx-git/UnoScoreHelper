//
//  GameSessionVC+Timer.swift
//  GameCountHelper
//
//  Created by Vlad on 5/31/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit

extension GameSessionViewController {
    //MARK: - Timer stuff
    
    func startTimer()
        {
            timerStartTime = Date.init(timeIntervalSinceNow: 0.0)
            timer.invalidate()
    //        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(everySecondTimerFired(sender:)), userInfo: nil, repeats: true)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(everySecondTimerFired(sender:)), userInfo: nil, repeats: true)
        }
    
    func stopTimer()
    {
        timeElapsedBefore -= timerStartTime.timeIntervalSinceNow
        timer.invalidate()
    }
    
    @objc func everySecondTimerFired(sender: Timer)
    {
        let timeElapsedTimer: TimeInterval =  -timerStartTime.timeIntervalSinceNow
        let timeElapsedGeneral = timeElapsedBefore + timeElapsedTimer
//        session.time = timeElapsedGeneral
        
        
        topBarView.titleLabel.text = usualTimeString(from: timeElapsedGeneral)
        topBarView.titleLabel.setNeedsDisplay()
    }
}
