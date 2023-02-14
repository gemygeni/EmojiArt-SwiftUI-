//
//  EmjiArtModel.swift
//  EmojiArt (SwiftUI)
//
//  Created by AHMED GAMAL  on 01/02/2023.
//

import UIKit
struct EmojiArtModel : Codable{
        var background = Background.blank
        var emojis = [Emoji]()
private var uniqueEmojiId = 0
    
    init(){}
    struct Emoji : Identifiable, Codable {
        var text : String
        var id: Int
        var x : Int
        var y : Int
        var size : Int
    fileprivate init(text : String, id: Int,  x : Int, y : Int, size : Int){
            self.text = text
            self.id = id
            self.x = x
            self.y = y
            self.size = size
        }
    }
    
    init(json : Data) throws{
        self = try JSONDecoder().decode(EmojiArtModel.self, from: json)
    }

    
    init(url : URL) throws{
        let data = try Data(contentsOf: url)
            self = try EmojiArtModel(json: data)
       }
    
    
    
    
    
    
    mutating func addEmoji(_ text: String, at location: (x: Int, y: Int), size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(text: text, id: uniqueEmojiId, x: location.x, y: location.y, size: size))
    }
    
    func json() throws -> Data {
        do {
            return try JSONEncoder().encode(self)
        }
        catch{
            print("cant encode emojiArt due to \(error)")
            return Data()
        }
    }
    
    
}
