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
        @State private var choosenPaletteIndex = 0

        @EnvironmentObject var store : PaletteStore
        var body: some View {
            HStack{
                paletteControlButton
                body(for: store.palette(at: choosenPaletteIndex))
            }.clipped()
        }
        var paletteControlButton : some View{
                Button {
                    withAnimation {
                        choosenPaletteIndex = (choosenPaletteIndex + 1) % store.palettes.count
                    }
                } label: {
                    Image(systemName: "paintpalette")
                }.font(emojiFont)
           }
        
        func body(for palette: Palette) -> some View {
            HStack {
                ScrollingEmojisView(emojis: palette.emojis)
                    .font(.system(size: emojiFontSize))
            }.transition(rollTransition)
                .id(palette.id)
        }
        var rollTransition: AnyTransition {
            AnyTransition.asymmetric(
                insertion: .offset(x: 0, y: emojiFontSize),
                removal: .offset(x: 0, y: -emojiFontSize)
            )
        }

        
    }

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
