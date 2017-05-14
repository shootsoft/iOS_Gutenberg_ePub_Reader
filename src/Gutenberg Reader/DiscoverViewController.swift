import UIKit

class DiscoverViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet var buttonHome: UIBarButtonItem!
    @IBOutlet var buttonBackward: UIBarButtonItem!
    @IBOutlet var buttonForward: UIBarButtonItem!
    @IBOutlet var webViewMain: UIWebView!
    
    let downloadManager = DownloadManager()
    let homePageUrl = URL(string: "https://m.gutenberg.org")
    
    
    @IBAction func buttonHomeAction(_ sender: UIBarButtonItem) {
        webViewMain.loadRequest(URLRequest(url: self.homePageUrl!))
    }
    
    @IBAction func buttonBackwardAction(_ sender: UIBarButtonItem) {
        if webViewMain.canGoBack {
            webViewMain.goBack()
        }
    }
    
    @IBAction func buttonForwardAction(_ sender: UIBarButtonItem) {
        if webViewMain.canGoForward {
            webViewMain.goForward()
        }
    }
    
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        return downloadManager.visitingBegin(view: self, webView: webView, request: request)
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        buttonBackward.isEnabled =  webViewMain.canGoBack
        buttonForward.isEnabled =  webViewMain.canGoForward
        downloadManager.visitingEnd(webView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let userAgent = webViewMain.stringByEvaluatingJavaScript(from: "navigator.userAgent") {
            downloadManager.setUserAgent(userAgent: userAgent)
        }
        buttonHomeAction(self.buttonHome)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

