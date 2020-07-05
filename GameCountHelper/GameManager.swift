//
//  GameManager.swift
//  GameCountHelper
//
//  Created by Vlad on 5/14/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import CoreData

extension UDStoredKey {
    static let savedGameStartDate = UDStoredKey("last unfinished game start date")
    static let savedSettings = UDStoredKey("game settings")
}

class GameManager {
    
    static let shared = GameManager()
    
//    init() {
//        game = cdStack.viewContext()
//    }
    
    let cdStack = CDStack()
    
    var settings: GameSettings
    
    var currentSession: GameSession?
    
    var playerCount: Int {
        return currentSession?.players.count ?? 0
    }
    
    var storedGameDate = UDStored<Date>(key: .savedGameStartDate)
    
    var storedSettings = UDStored<GameSettings>(key: .savedSettings)
    
    private(set) var skin = Skin()
    
    init() {
        if let loadedSettings = storedSettings.value {
            settings = loadedSettings
        } else {
            settings = GameSettings()
        }
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(save), name: UIScene.willDeactivateNotification, object: nil)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(save), name: UIApplication.willResignActiveNotification, object: nil)
        }
        if let storedDate = storedGameDate.value {
            let predicate = NSPredicate(format: "start == %@", storedDate as NSDate)
            currentSession = GameSession.fetch(predicate: predicate, context: cdStack.viewContext())
            if let game = currentSession {
                for player in game.players {
                    player.loadImage()
                }
            }
        }
        if let skin = SkinManager.loadSkinWithName(settings.skinName ?? SkinManager.defaultSkinName) {
            setSkin(skin)
        }
    }
    
    func newSession(with players: [Player]) -> GameSession {
        currentSession = GameSession.newInstance(for: players)
        cdStack.viewContext().saveIfNeed()
        storedGameDate.value = currentSession?.start
        return currentSession!
    }
    
    func storedSessionDate() -> Date? {
        return storedGameDate.value
    }
    
    func setSkin(_ skin: Skin) {
        self.skin = skin
        settings.skinName = skin.name
    }
    
    @objc func save() {
        cdStack.viewContext().saveIfNeed()
    }
}

protocol CommonDataAccess {
    var viewContext: NSManagedObjectContext {get}
}

extension CommonDataAccess {
    var viewContext: NSManagedObjectContext {
        return GameManager.shared.cdStack.viewContext()
    }
}
