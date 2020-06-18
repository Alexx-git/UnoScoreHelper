//
//  ViewAnimator.swift
//  Crypto
//
//  Created by Vlad on 10/29/18.
//  Copyright © 2018 ALEXANDER. All rights reserved.
//

import UIKit

func mainAsyncAfter(_ s: Double, action: @escaping (()->())) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(s * 1000.0)), execute: action)
}


struct AnimationTimes {
	var duration:TimeInterval
	var delay:TimeInterval
	static func ms(_ duration:TimeInterval, delay:TimeInterval) -> AnimationTimes {
		return AnimationTimes(duration: duration * 0.001, delay: delay * 0.001)
	}
}

class ViewAnimator {
	static var factor = 1.0
	var duration = 0.2
	var delay = 0.0
	var options: UIView.AnimationOptions = UIView.AnimationOptions.curveEaseIn
	var before: (() -> Swift.Void)?
	var animation: (() -> Swift.Void)?
	var completion: ((Bool) -> Swift.Void)?
	
	init(_ duration:TimeInterval, _ delay:TimeInterval = 0.0, options:UIView.AnimationOptions? = nil) {
		self.duration = duration
		self.delay = delay
		if options != nil {
			self.options = options!
		}
	}
	
	init(times:AnimationTimes, options:UIView.AnimationOptions? = nil) {
		self.duration = times.duration
		self.delay = times.delay
		if options != nil {
			self.options = options!
		}
	}
	
	func run() {
		if before != nil {
            mainAsyncAfter(delay * ViewAnimator.factor) {
				self.before!()
				self.performAnimation(changedDelay:0.0)
			}
		}
		else{
			self.performAnimation(changedDelay:delay)
		}
	}
	
	func performAnimation(changedDelay:TimeInterval) {
		if animation != nil {
			UIView.animate(withDuration:duration * ViewAnimator.factor, delay:changedDelay * ViewAnimator.factor, options: options,
						   animations: animation!, completion: completion)
		}
	}
	
	func animate(_ animation:@escaping () -> Swift.Void) {
		self.animation = animation
		self.run()
	}
	
	func complete(_ completion:@escaping (Bool) -> Swift.Void) {
		self.completion = completion
		self.run()
	}
}


class ViewSpringAnimator: ViewAnimator {
	var damping:CGFloat = 0.35
	var velocity:CGFloat = 0.7
	
	@discardableResult func spring(damping:CGFloat, velocity:CGFloat) -> ViewSpringAnimator {
		self.damping = damping
		self.velocity = velocity
		return self
	}
	
	override func performAnimation(changedDelay:TimeInterval) {
		if animation != nil {
			UIView.animate(
				withDuration: duration * ViewAnimator.factor,
				delay: changedDelay * ViewAnimator.factor,
				usingSpringWithDamping: damping,
				initialSpringVelocity: velocity,
				options: options,
				animations: animation!,
				completion: completion
			)
		}
	}
}
