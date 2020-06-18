//
//  CommonOperators.swift
//  Common
//
//  Created by Vlad on 5/16/19.
//  Copyright © 2019 ALEXANDER. All rights reserved.
//

import Foundation

prefix operator ??
prefix func ??(b: Bool?) -> Bool {
	return b ?? false
}

prefix func ??(a: Any?) -> Bool {
	return (a == nil) ? false : true
}

//postfix func =?(b: Bool?) -> Bool {
//	return b ?? false
//}
//
//postfix func =?(a: Any?) -> Bool {
//	return (a == nil) ? false : true
//}
//
//func =?(b: Bool?) -> Bool {
//	return b ?? false
//}

//postfix func =?(a: Any?) -> Bool {
//	return (a == nil) ? false : true
//}

//infix operator ?= {}
//func ?= <T>(inout left: T, right: T?) {
//	if let right = right {
//		left = right
//	}
//}
//
//// overload to deal with an optional left handed side
//func ?= <T>(inout left: T?, right: T?) {
//	if let right = right {
//		left = right
//	}
//}


