//
//  CP+DispatchQueue.swift
//  CustomerPortal
//
//  Created by Vlad on 1/2/20.
//  Copyright © 2020 Corrigo Inc. All rights reserved.
//

import Foundation

extension DispatchQueue {
	
	func asyncAfter(seconds: Double, execute work: @escaping () -> Void) {
		self.asyncAfter(deadline: .now() + .milliseconds(Int(seconds * 1000.0)), execute: work)
	}
}
