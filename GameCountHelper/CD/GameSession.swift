//
//  Game.swift
//  GameCountHelper
//
//  Created by Vlad on 5/9/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import CoreData

@objc(GameSession)
class GameSession: NSManagedObject, CoreDataEntity {
    
    @NSManaged public var name: String?
    @NSManaged public var start: Date?
    @NSManaged public var finish: Date?
    @NSManaged private var rounds_ordered: NSOrderedSet
    @NSManaged private var players_ordered: NSOrderedSet
    
    public var rounds: [Round] {
        get {
            return (rounds_ordered.array as? [Round]) ?? []
        }
        set(newValue) {
            rounds_ordered = NSOrderedSet(array: newValue)
        }
    }
    
    public var players: [Player] {
        get {
            return (players_ordered.array as? [Player]) ?? []
        }
        set(newValue) {
            players_ordered = NSOrderedSet(array: newValue)
        }
    }
}

extension GameSession {
    class func entityName() -> String {
        return "GameSession"
    }
    
    class func newInstance(for players: [Player]) -> GameSession {
        let game = GameSession.createObject(context: GameManager.shared.cdStack.viewContext())
        game.players = players
        game.name = ""
        game.start = Date.init(timeIntervalSinceNow: .zero)
        return game
    }
    
    func newRound(with values: [Int]) -> Round {
        let context = GameManager.shared.cdStack.viewContext()
        let round = Round.createObject(context: context)
        for (index, player) in players.enumerated() {
            round.score[player.id] = values[index]
        }
        rounds.append(round)
        context.saveIfNeed()
        return round
    }
    
    class func instance(started date: Date) -> GameSession? {
        let context = GameManager.shared.cdStack.viewContext()
        let predicate = NSPredicate(format: "start == %@", date as NSDate)
        let game = GameSession.fetchItems(predicate: predicate, context: context)?.first
        return game
    }
}
