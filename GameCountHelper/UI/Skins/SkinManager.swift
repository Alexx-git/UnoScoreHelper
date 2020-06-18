//
//  SkinManager.swift
//  Crypto
//
//  Created by Vlad on 2/18/19.
//  Copyright © 2019 ALEXANDER. All rights reserved.
//

import UIKit

class SkinManager {
    
    static let decoder = JSONDecoder()
    
    static let defaultSkinName = "Simple"
    
    static let skinsPath = Bundle.main.path(forResource: "skins", ofType: "") ?? ""
    
    private class func loadSkinAtURL(_ url: URL, decoder: JSONDecoder) -> Skin?{
        do {
            let data = try Data(contentsOf: url)
            let skin = try decoder.decode(Skin.self, from: data)
            return skin
        }
        catch let error {
            print("Error when reading json file \(error)")
        }
        return nil
    }
    
    class func loadSkinWithName(_ name: String) -> Skin? {
        let file = (name as NSString).appendingPathExtension("json") ?? name
        let skinsURL = URL(fileURLWithPath: Self.skinsPath)
        let fileURL = skinsURL.appendingPathComponent(file)
        print("fileURL: \(fileURL)")
        let skin = loadSkinAtURL(fileURL, decoder: decoder)
//        print("skin: \(skin)")
        skin?.name = name
        return skin
    }
    
    
    class func loadSkins() -> [Skin] {
        var skins = [Skin]()
        
        let skinsURL = URL(fileURLWithPath: skinsPath)
        if let files = try?
            FileManager.default.contentsOfDirectory(atPath: skinsPath){
            for file in files {
                print("file: \(file)")
                let fileURL = skinsURL.appendingPathComponent(file)
                print("fileURL: \(fileURL)")
                if let skin = loadSkinAtURL(fileURL, decoder: decoder) {
                    print("skin: \(skin)")
                    skin.name = (file as NSString).deletingPathExtension
                    skins.append(skin)
                }
                print("skins: \(skins)")
            }
        }
        return skins
 
    }
    
}

