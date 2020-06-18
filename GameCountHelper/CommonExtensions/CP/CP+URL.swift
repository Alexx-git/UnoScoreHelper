//
//  CP+URL.swift
//  CustomerPortal
//
//  Created by Vlad on 5/27/19.
//  Copyright © 2019 Corrigo Inc. All rights reserved.
//

import Foundation

extension URL {
	
	var command: String? {
		return self.host?.lowercased()
	}
	
	var parameters: [String: String] {
		var dict = [String: String]()
		let urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)
		for item in urlComponents?.queryItems ?? [] {
			dict[item.name] = item.value
		}
		return dict
	}
}

