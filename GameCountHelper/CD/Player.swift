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
    
    var image: UIImage?
    
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
    
    func saveImage() {
        guard let image = image else {return}
        guard let data = image.jpegData(compressionQuality: 1) else {return}
        let fm = FileManager.default
        guard let documentsDirectory = fm.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        let fileURL = documentsDirectory.appendingPathComponent("\(id).jpg")
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch let removeError {
                print(removeError)
            }
        }
        do {
            try data.write(to: fileURL)
        } catch let error {
            print(error)
        }
    }
        
    func loadImage() -> UIImage? {
        let fm = FileManager.default
        guard let documentsDirectory = fm.urls(for: .documentDirectory, in: .userDomainMask).first else {return nil}
        let fileURL = documentsDirectory.appendingPathComponent("\(id).jpg")
        guard fm.fileExists(atPath: fileURL.path) else {return nil}
        do {
            let data = try Data(contentsOf: fileURL)
            image = UIImage(data: data)
            return image
        } catch let error {
            print(error)
        }
        return nil
    }
}
