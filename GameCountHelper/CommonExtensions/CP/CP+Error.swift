//
//  CP+Error.swift
//  CustomerPortal
//
//  Created by Vlad on 1/18/20.
//  Copyright © 2020 Corrigo Inc. All rights reserved.
//

import Foundation

extension Error {
	var code: Int { return (self as NSError).code }
	var domain: String { return (self as NSError).domain }
}
