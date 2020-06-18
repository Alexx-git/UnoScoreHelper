//
//  UDStored.swift
//  GameCountHelper
//
//  Created by Vlad on 5/14/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import Foundation

extension UDStoredKey {
    static let myDate = UDStoredKey("myDate")
}

class SomeClass  {
    var someDate = UDStored<Date>(key: .myDate)
}

import Foundation

public struct UDStoredKey : RawRepresentable, Equatable, Hashable {
    public var rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }
    public init(_ rawValue: String) { self.rawValue = rawValue }
}

public class UDStored<T: Codable> {
    let key: String
    
    private init(key: String, value:T? = nil) {
        self.key = key
        if value != nil {
            self.value = value
        }
    }
    
    convenience init(key: UDStoredKey, value:T? = nil) {
        self.init(key: key.rawValue)
    }
    
    var value: T? {
        get {
            return T.udStored(forKey: key)
        }
        set {
            if let v = newValue {
                v.udSave(forKey: key)
            }
            else {
                T.udReset(forKey: key)
            }
        }
    }
}

extension Decodable {
    
    static func udStored(forKey key: String? = nil) -> Self? {
        let storeKey = key ?? String(describing: self)
        if let data = UserDefaults.standard.data(forKey: storeKey) {
            do{
                // PropertyListEncoder does not support single primitive types like Int (i.e. have no allowFragments option)
                // so as a workaround all objects are wrapped in Array
                let arr = try  PropertyListDecoder().decode([Self].self, from: data)
                print("udStored:\(String(describing: arr.first))")
                return arr.first
            }
            catch let error {
                print("udStored Error:\(error)")
            }
        }
        return nil
    }
    
    static func udReset(forKey key: String? = nil) {
        let storeKey = key ?? String(describing: self)
        UserDefaults.standard.removeObject(forKey: storeKey)
        UserDefaults.standard.synchronize()
    }
}

extension Encodable {
    func udSave(forKey key: String? = nil) {
        let storeKey = key ?? String(describing: Self.self)
        do{
            print("udSave:\(String(describing: self))")
            let data = try PropertyListEncoder().encode([self])
            UserDefaults.standard.set(data, forKey: storeKey)
            UserDefaults.standard.synchronize()
        } catch let error {
            print("udSave Error:\(String(describing: error))")
        }
    }
}
