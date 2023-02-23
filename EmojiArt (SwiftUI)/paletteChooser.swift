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
        @SceneStorage("PaletteChooser.chosenPaletteIndex") private var chosenPaletteIndex = 0
        @State var managing = false
        @State private var paletteToEdit : Palette?
        @EnvironmentObject var store : PaletteStore
        
        var body: some View {
            HStack{
                paletteControlButton
                Text(store.palette(at: chosenPaletteIndex).name)
                body(for: store.palette(at: chosenPaletteIndex))
            }.clipped()
        }
        var paletteControlButton : some View{
                Button {
                    withAnimation {
                        chosenPaletteIndex = (chosenPaletteIndex + 1) % store.palettes.count
                    }
                } label: {
                    Image(systemName: "paintpalette")
                }.font(emojiFont)
                .contextMenu{contextMenu}
           }
        
        func body(for palette: Palette) -> some View {
            HStack {
                ScrollingEmojisView(emojis: palette.emojis)
                    .font(.system(size: emojiFontSize))
            .transition(rollTransition)
                .id(palette.id)
                .popover(item: $paletteToEdit, content: { palette in
                    paletteEditor(palette: $store.palettes[palette])
                        .wrappedInNavigationViewToMakeDismissable {
                            paletteToEdit = nil
                        }
                }
                ).sheet(isPresented: $managing) {
                    PaletteManager()
                }
            }
        }
        var rollTransition: AnyTransition {
            AnyTransition.asymmetric(
                insertion: .offset(x: 0, y: emojiFontSize),
                removal: .offset(x: 0, y: -emojiFontSize)
            )
        }

        @ViewBuilder
        var contextMenu: some View {
            AnimatedActionButton(title: "Manager", systemImage: "slider.vertical.3") {
                managing = true
            }

            AnimatedActionButton(title: "Edit", systemImage: "pencil") {
                paletteToEdit = store.palette(at: chosenPaletteIndex)
            }

            
            AnimatedActionButton(title: "New", systemImage: "plus") {
                store.insertPalette(named: "New", emojis: "", at: chosenPaletteIndex)
                paletteToEdit = store.palette(at: chosenPaletteIndex)
            }

            AnimatedActionButton(title: "Delete", systemImage: "minus.circle") {
                chosenPaletteIndex = store.removePalette(at: chosenPaletteIndex)
            }
            gotoMenu

        }
        
        var gotoMenu: some View {
            Menu {
                ForEach (store.palettes) { palette in
                    AnimatedActionButton(title: palette.name) {
                        if let index = store.palettes.index(matching: palette) {
                            chosenPaletteIndex = index
                        }
                    }
                }

            } label: {
                Label("Go To", systemImage: "text.insert")
            }
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
