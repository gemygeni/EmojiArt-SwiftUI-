//
//  PaletteManager.swift
//  EmojiArt (SwiftUI)
//
//  Created by AHMED GAMAL  on 18/02/2023.
//

import SwiftUI

struct PaletteManager: View {
    @EnvironmentObject var store : PaletteStore
    @State private var editMode: EditMode = .inactive

    @Environment (\.colorScheme) private var colorScheme
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            List {
                ForEach(store.palettes) { palette in
                    NavigationLink(destination: paletteEditor(palette: $store.palettes[palette])) {
                        VStack(alignment: .leading){
                            Text(palette.name)
                            Text(palette.emojis)
                        }.gesture(editMode == .active ? tap : nil)
                        
                    }
                }
                .onDelete { indexset in
                    store.palettes.remove(atOffsets: indexset)
                }
                .onMove { indexset, newOffset in
                    store.palettes.move(fromOffsets: indexset, toOffset: newOffset)

                }
            }
            .navigationTitle("Manage Palette")
            .navigationBarTitleDisplayMode(.inline)
            .dismissable { presentationMode.wrappedValue.dismiss() }
//            .toolbar {
//                ToolbarItem { EditButton() }
//                ToolbarItem(placement: .navigationBarLeading) {
//                    if presentationMode.wrappedValue.isPresented,
//                       UIDevice.current.userInterfaceIdiom != .pad {
//                        Button("Close") {
//                            presentationMode.wrappedValue.dismiss()
//                        }
//                    }
//                }
//            }
            .environment(\.editMode, $editMode)
        }
    }
    
    
    var tap: some Gesture {
        TapGesture().onEnded { }
    }

}

struct PaletteManager_Previews: PreviewProvider {
    static var previews: some View {
        PaletteManager()
            .previewDevice("iPhone 14 Pro Max")
            .environmentObject(PaletteStore(named: "preview"))
            .preferredColorScheme(.light)
    }
}
