import UIKit

class BaseManager: NSObject {
    
    let fileManager = FileManager.default
    let folderName = "Downloaded"
    var localUrl:URL?
   
    override public init() {
        super.init()
        localUrl = prepareCacheFolder(name: folderName)
        if localUrl == nil {
            print("Prepare failed!")
        }
    }
    
    func prepareCacheFolder(name:String) -> URL? {
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let fullPath = paths.first! + "/\(name)/"
        let pathUrl = URL(string: fullPath)
        var isDir : ObjCBool = false
        if fileManager.fileExists(atPath: fullPath, isDirectory:&isDir) && isDir.boolValue {
            return pathUrl
        } else {
            do {
                try fileManager.createDirectory(atPath: fullPath, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription);
                return nil
            }
        }
        return pathUrl
    }
    
    public func showMessage(view: UIViewController, title: String, message: String) {
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
        }))
        
        view.present(refreshAlert, animated: true, completion: nil)
    }
}
