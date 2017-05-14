//
//  DownloadManager.swift
//  Gutenberg Reader
import UIKit
import SwiftHTTP

class DownloadManager: BaseManager {

    // Download
    var cookies=[String: String]()
    var userAgent = ""
    var referer = ""
    
    let downloadRegex = "\\.epub\\?"
    let disabledRegex = "\\.(mobi)\\?"
    
    public func setUserAgent(userAgent:String) {
        self.userAgent = userAgent
    }
    
    public func setCookie(key:String,val:String) {
        self.cookies[key] = val
    }
    
    public func setReferer(referer:String) {
        self.referer = referer
    }
    
    public func visitingBegin(view: UIViewController, webView: UIWebView,request: URLRequest) -> Bool{
        let url = request.mainDocumentURL!.absoluteString
        print("Visiting url: \(url)")
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                setCookie(key: cookie.name, val: cookie.name)
            }
        }
        if isDisabled(downloadUrl: url) {
            showMessage(view: view, title: "Sorry", message: "Format not supported yet.")
            return false
        } else if isDownloadable(downloadUrl: url) {
            if download(downloadUrl: url) {
                showMessage(view: view, title: "Downloading", message: "Downloading in progress. Check your [Library].")
            }
            return false
        }
        setReferer(referer: url)
        return true

        
    }
    
    public func visitingEnd(_ webView: UIWebView) {
        
    }
    
    
    func isDownloadable(downloadUrl:String) -> Bool {
        if downloadUrl.range(of: downloadRegex, options: String.CompareOptions.regularExpression) != nil {
            print("Yes it does \(downloadUrl)")
            return true
        }
        return false
    }
    
    func isDisabled(downloadUrl:String) -> Bool {
        if downloadUrl.range(of: disabledRegex, options: String.CompareOptions.regularExpression) != nil {
            print("Sorry it is diabled \(downloadUrl)")
            return true
        }
        return false
    }
    
    func getHeaders() -> [String:String] {
        var cookie = ""
        for (key,value) in self.cookies {
            cookie += "\(key)=\(value); "
        }
        
        return ["Referer": self.referer, "User-Agent": self.userAgent, "Cookie:":cookie]
    }
    
    func download(downloadUrl:String) -> Bool {
        do {
            let headers = getHeaders()
            print("Downloading: \(downloadUrl) with headers: \(headers)")
            let opt = try HTTP.Download(downloadUrl, headers: headers, completion: { (url) in
                print("Downloaded: \(url)")
                let targetUrl = URL(fileURLWithPath: "\(self.localUrl!.absoluteString)\(url.lastPathComponent).epub")
                //let targetUrl =  self.localUrl!.absoluteURL.appendingPathComponent(url.lastPathComponent).appendingPathExtension("epub")
                print("Target: \(targetUrl)")
                if self.fileManager.fileExists(atPath: url.path) {
                    do {
                        try self.fileManager.moveItem(at: url, to: targetUrl)
                    }
                    catch let error as NSError {
                        print("Ooops! Something went wrong: \(error)")
                    }
                } else {
                    print ("File not found: \(url)")
                }
                
            })
            opt.start()
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        return true
    }
}
