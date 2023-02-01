//
//  EmjiArtModel.swift
//  EmojiArt (SwiftUI)
//
//  Created by AHMED GAMAL  on 01/02/2023.
//

import UIKit
struct EmojiArtModel {
        var background = Background.blank
        var emojis = [Emoji]()
private var uniqueEmojiId = 0
    
    init(){}
    struct Emoji : Identifiable {
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
    
    
    mutating func addEmoji(_ text: String, at location: (x: Int, y: Int), size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(text: text, id: uniqueEmojiId, x: location.x, y: location.y, size: size))
    }
}
