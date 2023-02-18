//
//  EmojiArtDocument.swift
//  EmojiArt (SwiftUI)
//
//  Created by AHMED GAMAL  on 01/02/2023.
//

import SwiftUI
class EmojiArtDocument : ObservableObject{
    @Published private(set) var emojiArt : EmojiArtModel{
        didSet {
            if emojiArt.background != oldValue.background {
                fetchBackgroundImageDataIfNecessary()
                autoSave()
            }
        }
    }
    
    init(){
        if let url = AutoSave.url, let autoSavedDocument = try? EmojiArtModel(url: url){
         emojiArt = autoSavedDocument
        fetchBackgroundImageDataIfNecessary()
        }else{
            self.emojiArt = EmojiArtModel()
           }
        }
    
    var background : EmojiArtModel.Background{emojiArt.background}
    var emojis : [EmojiArtModel.Emoji]{emojiArt.emojis}
    @Published var backgroundImage: UIImage?
    @Published var backgroundImageFetchStatus = BackgroundImageFetchStatus.idle

    enum BackgroundImageFetchStatus : Equatable {
        case idle
        case fetching
        case failed(URL)
    }

    private func fetchBackgroundImageDataIfNecessary() {
        backgroundImage = nil
        switch emojiArt.background {
        case .url(let url):
            backgroundImageFetchStatus = .fetching
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData = try? Data(contentsOf: url)
                DispatchQueue.main.async { [weak self] in
                    if self?.emojiArt.background == EmojiArtModel.Background.url(url) {
                        self?.backgroundImageFetchStatus = .idle
                        if imageData != nil {
                            self?.backgroundImage = UIImage(data: imageData!)
                        }
                        if self?.backgroundImage == nil{
                        self?.backgroundImageFetchStatus = .failed(url)
                        }
                    }
                }
            }
        case .imageData(let data):
            backgroundImage = UIImage(data: data)
        case .blank:
            break
        }
    }
 
    private struct AutoSave{
        static  let fileName = "autoSaved document"
        static var url : URL?{
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            return documentDirectory?.appendingPathComponent(fileName)
        }
    }
    
        
    // MARK: - Intent(s)
    private func autoSave(){
        if let url = AutoSave.url{
            save(to: url)
        }
    }
    
    
    
    private func save(to url : URL) {
        let thisFunction = "String(describing: \(self)).\(#function)"
        do{
            let data : Data = try emojiArt.json()
            print("\(thisFunction) json =  \(String(data: data, encoding: .utf8) ?? "nil") ")
            try data.write(to: url)
            print("\(thisFunction) success!")

        }
        catch let encodingError where encodingError is EncodingError{
            print("\(thisFunction) can't encode this data because \(encodingError)")
        }
        catch {
            print("\(thisFunction) can't encode this data because \(error.localizedDescription)")
        }
    }
    
    func setBackground(_ background: EmojiArtModel.Background) {
        emojiArt.background = background
    }
    
    func addEmoji(_ emoji: String, at location: (x: Int, y: Int), size: CGFloat) {
        emojiArt.addEmoji(emoji, at: location, size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArtModel.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArtModel.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrAwayFromZero))
        }
    }

}
