//
//  Decodable+Common.swift
//  Crypto
//
//  Created by Vlad on 4/1/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import Foundation

extension KeyedDecodingContainer {
    func setIfDecoded<T: Decodable>  (_ obj: inout T, key: KeyedDecodingContainer<K>.Key) {
        do {
            if let decodedObj = try (self.decodeIfPresent(type(of: obj), forKey: key)) {
                obj = decodedObj
            }
        }
        catch let error {
            print("Error when reading json file \(error)")
        }
    }
}
