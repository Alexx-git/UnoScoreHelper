//
//  CP+AnyHashable.swift
//  CustomerPortal
//
//  Created by Vlad on 7/30/19.
//  Copyright © 2019 Corrigo Inc. All rights reserved.
//

import Foundation

extension AnyHashable {
	var string: String? {
		return self as? String
	}
	
	var int: Int? {
		return self as? Int
	}
}
