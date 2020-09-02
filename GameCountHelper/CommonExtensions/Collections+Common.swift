//
//  Collections+Common.swift
//  Crypto
//
//  Created by Vlad on 4/21/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import Foundation

extension Collection {
    
    // Returns the element at the specified index if it is within bounds, otherwise nil.
    func at(_ index:Index?) -> Element? {
        if let index = index {
            return indices.contains(index) ? self[index] : nil
        }
        return nil
    }
    

}

extension Dictionary {
    
    mutating func setOptional(_ opt: Any?, forKey key:Key) {
        if let strValue = opt as? Value {
            self[key] = strValue
        }
    }
    
    subscript(key: Key?) -> Value? {

        get {
            guard let key = key else { return nil }
            return self[key]
        }
        set(newValue) {
            guard let key = key else { return }
            guard let value = newValue else { return }
            self[key] = value
        }
    }
    
    func appending(_ other: [Key: Value]) -> [Key: Value] {
        return self.merging(other) { (_, new) in new }
    }

}


extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(_ object: Element) {
        guard let index = firstIndex(of: object) else {return}
        remove(at: index)
    }
    
    func firstIndexOfOptional(_ element: Element?) -> Self.Index? {
        if let element = element {
            return firstIndex(of: element)
        }
        return nil
    }
    
}

extension Array {
    func pretty() -> String {
        var str = ""
        var ind = 0
        for element in self {
            str += "\n[\(ind)]:\(element) "
            ind += 1
        }
        return "Array: [\(str)]"
    }

    mutating func appendOptional(_ optionalElement: Element?) {
        if let element = optionalElement {
            append(element)
        }
    }
}

extension Dictionary {
    func pretty() -> String {
        var str = ""
        for (key, value) in self {
            str += "\nKey: \(key), Value: \(value) "
        }
        return "Dictionary: [\(str)]"
    }
}

extension IndexPath {
    static func pathsForSection(_ section: Int, numberOfRows: Int) -> [IndexPath] {
        return (0..<numberOfRows).map{IndexPath(item: $0, section: section)}
    }
}
