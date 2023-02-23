//
//  EmojiArt__SwiftUI_App.swift
//  EmojiArt (SwiftUI)
//
//  Created by AHMED GAMAL  on 01/02/2023.
//

import SwiftUI

@main
struct EmojiArt__SwiftUI_App: App {
   @StateObject var paletteStore = PaletteStore(named: "Default")
    var body: some Scene {
//        WindowGroup {
//            EmojiArtDocumentView(document: document)
//                .environmentObject(paletteStore)
//        }
        
        DocumentGroup(newDocument: { EmojiArtDocument() }) { config in
            EmojiArtDocumentView(document: config.document)
                .environmentObject(paletteStore)
        }

        
    }
}
