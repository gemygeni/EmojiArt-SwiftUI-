//
//  paletteEditor.swift
//  EmojiArt (SwiftUI)
//
//  Created by AHMED GAMAL  on 17/02/2023.
//

import SwiftUI

struct paletteEditor: View {
    @Binding var palette : Palette
    var body: some View {
        Form{
            nameSection
            editSection
        }.frame(minWidth: 350, minHeight: 400)
    
        
    }
    
    var nameSection : some View{
        Section(header: Text("Name")) {
            TextField("Name", text: $palette.name)

        }
        

    }
    
    @State var emojisToAdd = ""
    var editSection : some View{
        Section(header: Text("Add Emojis")) {
            TextField("", text: $emojisToAdd)
                .onChange(of: emojisToAdd) { emoji in
                    AddEmoji(emoji)
                }

        }

    }

    private func AddEmoji(_ emojis : String){
        withAnimation {
            let emojis =  emojis.filter {$0.isEmoji}.removingDuplicateCharacters
               palette.emojis = emojis + palette.emojis
        }
    }
    
    
    
    
    
    
    
    
    
}


struct paletteEditor_Previews: PreviewProvider {
    static var previews: some View {
        paletteEditor(palette: .constant(PaletteStore(named: "Preview").palette(at: 3)))
            .previewLayout(.fixed(width: 50, height: 50))
    }
}
