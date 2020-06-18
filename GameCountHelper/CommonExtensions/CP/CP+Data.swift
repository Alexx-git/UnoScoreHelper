//
//  CP+Data.swift
//  CustomerPortal
//
//  Created by Vlad on 4/22/19.
//  Copyright © 2019 Corrigo Inc. All rights reserved.
//

import Foundation


extension Data {
	private static let hexChars = "0123456789abcdef".unicodeScalars.map { $0 }
	
	public func hexString() -> String {
		return String(self.reduce(into: "".unicodeScalars, { (result, value) in
			result.append(Data.hexChars[Int(value/16)])
			result.append(Data.hexChars[Int(value%16)])
		}))
	}
}

