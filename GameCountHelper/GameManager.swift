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
    static let savedPlayersIDs = UDStoredKey("ids for players in list if no session is saved")
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
    
    var players: [Player]?
    
    var storedGameDate = UDStored<Date>(key: .savedGameStartDate)
    
    var storedSettings = UDStored<GameSettings>(key: .savedSettings)
    
    var storedPlayersIDs = UDStored<Array<Int64>>(key: .savedPlayersIDs)
    
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
                    _ = player.loadImage()
                }
            }
        } else if let ids = storedPlayersIDs.value {
            let predicate = NSPredicate(format: "id IN %@", ids)
            players = Player.fetchItems(predicate: predicate, context: cdStack.viewContext())
        }
        if let skin = SkinManager.loadSkinWithName(settings.skinName ?? SkinManager.defaultSkinName) {
            self.skin = skin
        }
    }
    
    func newSession(with players: [Player]) -> GameSession {
        currentSession = GameSession.newInstance(for: players)
        cdStack.viewContext().saveIfNeed()
        storedGameDate.value = currentSession?.start
        return currentSession!
    }
    
    func finishSession() {
        guard let session = currentSession else {return}
        if session.rounds.count == 0 || session.players.count == 0 {
            cdStack.viewContext().delete(session)
        } else {
            currentSession?.finish = Date.init(timeIntervalSinceNow: 0)
        }
        currentSession = nil
        save()
        storedGameDate.value = nil
    }
    
    func storedSessionDate() -> Date? {
        return storedGameDate.value
    }
    
    func setSkin(_ skin: Skin) {
        self.skin = skin
        if settings.sameSkinForAllModes {
            settings.skinNames[.light] = skin.name
            settings.skinNames[.dark] = skin.name
        }
        else {
            settings.skinNames[UIStyle.current] = skin.name
        }
    }
    
    @objc func save() {
        settings.saveSettings()
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
