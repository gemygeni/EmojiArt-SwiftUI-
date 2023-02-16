//
//  paletteChooser.swift
//  EmojiArt (SwiftUI)
//
//  Created by AHMED GAMAL  on 17/02/2023.
//

import SwiftUI

struct paletteChooser: View {
    var emojiFontSize: CGFloat = 40
    var emojiFont: Font { .system(size: emojiFontSize) }

    var body: some View {
            ScrollingEmojisView(emojis: testEmojis)
                .font(.system(size: emojiFontSize))
    }
}
let testEmojis = "😀😷🦠💉👻👀🐶🌲🌎🌞🔥🍎⚽️🚗🚓🚲🛩🚁🚀🛸🏠⌚️🎁🗝🔐❤️⛔️❌❓✅⚠️🎶➕➖🏳️"

struct ScrollingEmojisView: View {
let emojis: String
var body: some View{
    ScrollView(.horizontal){
        HStack{
            ForEach(emojis.removingDuplicateCharacters.map{String($0)}, id : \.self){emoji in
               Text(emoji)
                    .onDrag {NSItemProvider(object: emoji as NSString)}
            }
        }
    }
  }
}

struct paletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        paletteChooser()
    }
}
