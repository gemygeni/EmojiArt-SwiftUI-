//
//  EmojiArtDocument.swift
//  EmojiArt (SwiftUI)
//
//  Created by AHMED GAMAL  on 01/02/2023.
//

import SwiftUI
import Combine
import UniformTypeIdentifiers
extension UTType{
    static let emojiart = UTType(exportedAs: "edu.stanford.cs193p.emojiart")
}

class EmojiArtDocument : ReferenceFileDocument{
    static var readableContentTypes = [UTType.emojiart]
    static var writeableContentTypes = [UTType.emojiart]

    func snapshot(contentType: UTType) throws -> Data {
        return try  emojiArt.json()
    }
    
    func fileWrapper(snapshot: Data, configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: snapshot)
    }
    
    required init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents{
          emojiArt = try EmojiArtModel(json: data)
            fetchBackgroundImageDataIfNecessary()
        }else{
            throw CocoaError(.fileReadCorruptFile)
        }
    }

    @Published private(set) var emojiArt : EmojiArtModel{
        didSet {
            if emojiArt.background != oldValue.background {
                fetchBackgroundImageDataIfNecessary()
             //   autoSave()
            }
        }
    }
    
    
    init(){
//        if let url = AutoSave.url, let autoSavedDocument = try? EmojiArtModel(url: url){
//         emojiArt = autoSavedDocument
//        fetchBackgroundImageDataIfNecessary()
//        }else{
            self.emojiArt = EmojiArtModel()
  //         }
        }
    
    private var backgroundImageFetchCancelable : AnyCancellable?
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
            backgroundImageFetchCancelable?.cancel()
            let session = URLSession.shared
            let publisher = session.dataTaskPublisher(for: url)
                .map{(data, response) in UIImage(data: data)}
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
            
            backgroundImageFetchCancelable = publisher
                //.assign(to: \EmojiArtDocument.backgroundImage, on: self)
                .sink(receiveValue: {[weak self] image in
                    self?.backgroundImage = image
                    self?.backgroundImageFetchStatus = image == nil ? .failed(url) : .idle
                })
            
            
            
            
            
            
            
//            DispatchQueue.global(qos: .userInitiated).async {
//                let imageData = try? Data(contentsOf: url)
//                DispatchQueue.main.async { [weak self] in
//                    if self?.emojiArt.background == EmojiArtModel.Background.url(url) {
//                        self?.backgroundImageFetchStatus = .idle
//                        if imageData != nil {
//                            self?.backgroundImage = UIImage(data: imageData!)
//                        }
//                        if self?.backgroundImage == nil{
//                        self?.backgroundImageFetchStatus = .failed(url)
//                        }
//                    }
//                }
//            }
        case .imageData(let data):
            backgroundImage = UIImage(data: data)
        case .blank:
            break
        }
    }
 
//    private struct AutoSave{
//        static  let fileName = "autoSaved document"
//        static var url : URL?{
//            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
//            return documentDirectory?.appendingPathComponent(fileName)
//        }
//    }
    
        
    // MARK: - Intent(s)
//    private func autoSave(){
//        if let url = AutoSave.url{
//            save(to: url)
//        }
//    }
    
//    private func save(to url : URL) {
//        let thisFunction = "String(describing: \(self)).\(#function)"
//        do{
//            let data : Data = try emojiArt.json()
//            print("\(thisFunction) json =  \(String(data: data, encoding: .utf8) ?? "nil") ")
//            try data.write(to: url)
//            print("\(thisFunction) success!")
//
//        }
//        catch let encodingError where encodingError is EncodingError{
//            print("\(thisFunction) can't encode this data because \(encodingError)")
//        }
//        catch {
//            print("\(thisFunction) can't encode this data because \(error.localizedDescription)")
//        }
//    }
    
    func setBackground(_ background: EmojiArtModel.Background, undoManager: UndoManager?) {
        undoablyPerform(operation: "Set Background", with: undoManager) {
            emojiArt.background = background
        }
    }
    
    func addEmoji(_ emoji: String, at location: (x: Int, y: Int), size: CGFloat, undoManager: UndoManager?) {
        undoablyPerform(operation: "Add \(emoji)", with: undoManager) {
            emojiArt.addEmoji(emoji, at: location, size: Int(size))
        }
    }
    
    func moveEmoji(_ emoji: EmojiArtModel.Emoji, by offset: CGSize, undoManager: UndoManager?) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            undoablyPerform(operation: "Move", with: undoManager) {
                emojiArt.emojis[index].x += Int(offset.width)
                emojiArt.emojis[index].y += Int(offset.height)
            }
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArtModel.Emoji, by scale: CGFloat, undoManager: UndoManager?) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            undoablyPerform(operation: "Scale", with: undoManager) {
                emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrAwayFromZero))
            }
        }
    }
    // MARK: - Undo
    
    private func undoablyPerform(operation: String, with undoManager: UndoManager? = nil, doit: () -> Void) {
        let oldEmojiArt = emojiArt
        doit()
        undoManager?.registerUndo(withTarget: self) { myself in
            myself.undoablyPerform(operation: operation, with: undoManager) {
                myself.emojiArt = oldEmojiArt
            }
        }
        undoManager?.setActionName(operation)
    }


}
