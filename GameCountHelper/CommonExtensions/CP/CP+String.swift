//
//  CP+String.swift
//  CustomerPortal
//
//  Created by Vlad on 4/8/19.
//  Copyright © 2019 Corrigo Inc. All rights reserved.
//

import Foundation

func hasText(_ str:String?) -> Bool {
	return (str == nil) ? false : str!.count > 0
}

func hasVisibleText(_ str:String?) -> Bool {
	return (str == nil) ? false : !str!.trimmingCharacters(in: .whitespaces).isEmpty
}

// Web + Html utils
extension String {

	var isHttpAddress: Bool {
		let value = lowercased()
		if value.hasPrefix("http://") {
			return true
		}
		if value.hasPrefix("https://") {
			return true
		}
		return false
	}

	var javaScriptEscaped: String {
		return replacingOccurrences(of: "\\", with: "\\\\")     // escape double quote
				.replacingOccurrences(of: "\"", with: "\\\"")     // escape double quote
				.replacingOccurrences(of: "\'", with: "\\\'")       // escape singe quote
				.replacingOccurrences(of: "\n", with: "\\n")        // escape EOL
				.replacingOccurrences(of: "\r", with: "")           // escape carriage return
	}

}


extension String {
	
	func byReplacingCharactersInSet(_ characterSet: CharacterSet, with string: String = "") -> String {
		return self.components(separatedBy: characterSet).joined(separator: string)
	}
	
	func urlPathSafeString() -> String {
		let characterSet = CharacterSet.urlPathAllowed
		let encoded = self.addingPercentEncoding(withAllowedCharacters: characterSet)
		return encoded ?? ""
	}
	
	func fileNameOnly() -> String {
		return NSURL(fileURLWithPath: self).deletingPathExtension?.lastPathComponent ?? ""
	}
	
	func fileExtension() -> String {
		return NSURL(fileURLWithPath: self).pathExtension ?? ""
	}
	
	//MARK: - Substrings
	
	subscript(value: NSRange) -> Substring {
		return self[value.lowerBound..<value.upperBound]
	}

	subscript(value: CountableClosedRange<Int>) -> Substring {
		get {
			return self[index(at: value.lowerBound)...index(at: value.upperBound)]
		}
	}
	
	subscript(value: CountableRange<Int>) -> Substring {
		get {
			return self[index(at: value.lowerBound)..<index(at: value.upperBound)]
		}
	}
	
	subscript(value: PartialRangeUpTo<Int>) -> Substring {
		get {
			return self[..<index(at: value.upperBound)]
		}
	}
	
	subscript(value: PartialRangeThrough<Int>) -> Substring {
		get {
			return self[...index(at: value.upperBound)]
		}
	}
	
	subscript(value: PartialRangeFrom<Int>) -> Substring {
		get {
			return self[index(at: value.lowerBound)...]
		}
	}
	
	func index(at offset: Int) -> String.Index {
		return index(startIndex, offsetBy: offset)
	}
	
}
