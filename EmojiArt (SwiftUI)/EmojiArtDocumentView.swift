//
//  ContentView.swift
//  EmojiArt (SwiftUI)
//
//  Created by AHMED GAMAL  on 01/02/2023.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    let defaultEmojiFontSize: CGFloat = 80
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            palette
        }
    }
    
    
    var documentBody : some View {
        ZStack{
            Color.yellow
            ForEach(document.emojis){emoji in
                Text(emoji.text)
            }
                
        }
        
    }
    let testEmojis = "😀😷🦠💉👻👀🐶🌲🌎🌞🔥🍎⚽️🚗🚓🚲🛩🚁🚀🛸🏠⌚️🎁🗝🔐❤️⛔️❌❓✅⚠️🎶➕➖🏳️"

    
    var palette : some View {
        ScrollingEmojisView(emojis: testEmojis)
            .font(.system(size: defaultEmojiFontSize))
            }
      }

struct ScrollingEmojisView: View {
    let emojis: String
    var body: some View{
        ScrollView(.horizontal){
            HStack{
                ForEach(emojis.map{String($0)}, id : \.self){emoji in
                   Text(emoji)
                }
            }
        }
    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView(document: EmojiArtDocument() )
    }
}
