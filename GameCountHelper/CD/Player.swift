//
//  Player.swift
//  GameCountHelper
//
//  Created by Vlad on 5/9/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import CoreData

@objc(Player)
class Player: NSManagedObject, CoreDataEntity {
    
    @NSManaged public var name: String?
    @NSManaged public var id: Int64
    @NSManaged private var games_ordered: NSOrderedSet
    
    public var games: [GameSession] {
        get {
            return (games_ordered.array as? [GameSession]) ?? []
        }
        set(newValue) {
            games_ordered = NSOrderedSet(array: newValue)
        }
    }
    
}
extension Player {
    class func entityName() -> String {
        return "Player"
    }
    
    class func newInstance() -> Player {
        let player = Player.createObject(context: GameManager.shared.cdStack.viewContext())
        player.name = ""
        player.games = []
        return player
    }
}
