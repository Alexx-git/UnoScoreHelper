//
//  Round.swift
//  GameCountHelper
//
//  Created by Vlad on 5/11/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import CoreData

@objc(Round)
class Round: NSManagedObject, CoreDataEntity {
    
    @NSManaged public var score: Dictionary<Int64, Int>
    @NSManaged public var game: GameSession
    
}

extension Round {
    class func entityName() -> String {
        return "Round"
    }
    
    var hasValues: Bool {
        for (_, value) in score {
            if value != 0 { return true }
        }
        return false
    }
}
