//
//  CP+RawRepresentable.swift
//  CustomerPortal
//
//  Created by Vlad on 9/17/19.
//  Copyright © 2019 Corrigo Inc. All rights reserved.
//

import Foundation

extension RawRepresentable {
	
	public init?(rawValue optionalRawValue: RawValue?) {
		
		guard let rawValue = optionalRawValue, let value = Self(rawValue: rawValue) else { return nil }
		
		self = value
	}
}
