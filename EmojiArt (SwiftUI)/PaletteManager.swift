//
//  PaletteManager.swift
//  EmojiArt (SwiftUI)
//
//  Created by AHMED GAMAL  on 18/02/2023.
//

import SwiftUI

struct PaletteManager: View {
    @EnvironmentObject var store : PaletteStore
    
    var body: some View {
        List {
            ForEach(store.palettes) { palette in
                VStack(alignment: .leading){
                    Text(palette.name)
                    Text(palette.emojis)
                }
            }
        }
    }
}

struct PaletteManager_Previews: PreviewProvider {
    static var previews: some View {
        PaletteManager()
            .environmentObject(PaletteStore(named: "preview"))
    }
}
