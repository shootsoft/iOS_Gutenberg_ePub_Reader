//
//  ViewManager.swift
//  Gutenberg Reader
//
//  Created by Yin Jun on 11/5/17.
//  Copyright © 2017 Yin Jun. All rights reserved.
//

import UIKit
import FolioReaderKit

class LibraryManager: BaseManager {

    public func getEpubFiles() -> [URL] {
        return getFileList(pathUrl: self.localUrl!, ext:"epub")
    }
    
    public func getTitle(url: URL) -> String {
        if let title = FolioReader.getTitle(url.path) {
            return title
        } else {
            return "Unknown \(url.lastPathComponent)"
        }
    }
    
    public func openEpub(parentViewController: UIViewController, epubFile: String) {
        let config = FolioReaderConfig()
        config.shouldHideNavigationOnTap = false
        config.scrollDirection = .horizontal
        
        // See more at FolioReaderConfig.swift
        //        config.canChangeScrollDirection = false
        //        config.enableTTS = false
        //        config.allowSharing = false
        //        config.tintColor = UIColor.blueColor()
        //        config.toolBarTintColor = UIColor.redColor()
        //        config.toolBarBackgroundColor = UIColor.purpleColor()
        //        config.menuTextColor = UIColor.brownColor()
        //        config.menuBackgroundColor = UIColor.lightGrayColor()
        //        config.hidePageIndicator = true
        //        config.realmConfiguration = Realm.Configuration(fileURL: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("highlights.realm"))
        
        // Custom sharing quote background
        //        let customImageQuote = QuoteImage(withImage: UIImage(named: "demo-bg")!, alpha: 0.6, backgroundColor: UIColor.black)
        //        let customQuote = QuoteImage(withColor: UIColor(red:0.30, green:0.26, blue:0.20, alpha:1.0), alpha: 1.0, textColor: UIColor(red:0.86, green:0.73, blue:0.70, alpha:1.0))
        //
        //        config.quoteCustomBackgrounds = [customImageQuote, customQuote]
        //
        print("Opening...\(epubFile)")
        // Epub file
        //let bookPath = Bundle.main.path(forResource: epubFile, ofType: "epub")
        FolioReader.presentReader(parentViewController: parentViewController, withEpubPath: epubFile, andConfig: config, shouldRemoveEpub: false)
    }
    
    func getFileList(pathUrl:URL, ext:String) -> [URL] {
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try fileManager.contentsOfDirectory(at:pathUrl, includingPropertiesForKeys: nil, options: [])
            
            print("pathUrl=\(pathUrl.absoluteString)")
            print("directoryContents=\(directoryContents)")
            
            let files = directoryContents.filter{ $0.pathExtension == ext }
            print("file urls:",files)
            return files
            //let mp3FileNames = epubFiles.map{ $0.deletingPathExtension().lastPathComponent }
            //print("epub list:", mp3FileNames)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return []
    }
    
    public func delete(filePathUrl:URL) -> Bool {
        do {
            try fileManager.removeItem(at: filePathUrl)
            return true
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        return false
    }
    
}
