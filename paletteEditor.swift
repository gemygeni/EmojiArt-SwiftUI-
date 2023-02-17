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
            TextField("Name", text: $palette.name)
        }.frame(minWidth: 350, minHeight: 400)
    }
}

struct paletteEditor_Previews: PreviewProvider {
    static var previews: some View {
     //   paletteEditor()
        Text("coming soon")
            .previewLayout(.fixed(width: 100, height: 100))
    }
}
