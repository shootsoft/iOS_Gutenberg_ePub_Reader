import UIKit

class LibraryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableViewBooks: UITableView!
    
    let libraryManager = LibraryManager()
    var epubFiles:[URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        epubFiles = libraryManager.getEpubFiles()
        tableViewBooks.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return epubFiles.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell (style: UITableViewCellStyle.default, reuseIdentifier: "BookCell")
        cell.textLabel?.text = ""
        cell.tag = indexPath.row
        cell.textLabel?.text = libraryManager.getTitle(url: epubFiles[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        libraryManager.openEpub(parentViewController: self, epubFile: epubFiles[indexPath.row].path)
    }
    
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            if libraryManager.delete(filePathUrl: epubFiles[indexPath.row]) {
                self.epubFiles.remove(at: indexPath.row)
            } else {
                libraryManager.showMessage(view: self,title: "Sorry", message: "File can't be deleted.")
            }
            tableView.reloadData()
        }
    }


}

