
import UIKit
import GEOSwift

class FirstColumnViewController: UITableViewController {
    
    var detailViewController: SecondColumnViewController? = nil
    var objects = [(fileName: String, geoData: GeoJSON)]()
    
    lazy var documentsBrwoserVC: UIDocumentBrowserViewController = {
        let documentsBrwoserVC = UIDocumentBrowserViewController()
        documentsBrwoserVC.allowsPickingMultipleItems = true
        documentsBrwoserVC.delegate = self
        documentsBrwoserVC.modalPresentationStyle = .fullScreen
        return documentsBrwoserVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.setRightBarButton(addButton, animated: false)
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? SecondColumnViewController
            detailViewController?.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            detailViewController?.navigationItem.leftItemsSupplementBackButton = true
        }
        
        if let path = Bundle.main.path(forResource:"Kantone", ofType: "shp"),
           let shapefileReader = try? ShapefileReader(path:path) {
            let shapes = shapefileReader.shp.allShapes()
        }
        //        objects.append()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    @objc func insertNewObject(_ sender: Any) {
        self.present(documentsBrwoserVC, animated: true, completion: nil)
    }

    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let object = objects[indexPath.row]
        cell.textLabel?.text = object.fileName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailViewController?.geoData = objects[indexPath.row].geoData
    }
}

extension FirstColumnViewController: UIDocumentBrowserViewControllerDelegate {
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        self.documentsBrwoserVC.dismiss(animated: true, completion: nil)
        documentURLs.forEach { url in
            let fileName = url.lastPathComponent
            let decoder = JSONDecoder()
            if let data = try? Data(contentsOf: url),
               let geoJSON = try? decoder.decode(GeoJSON.self, from: data) {
                
                objects.insert((fileName, geoJSON), at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                tableView.insertRows(at: [indexPath], with: .automatic)
                detailViewController?.geoData = geoJSON
//                switch geoJSON {
//                case .feature(let feature):
//                    let geometry = feature.geometry
//                case .featureCollection(let featureCollection):
//                    break
//                case .geometry(let geometry):
//                    break
//                default:
//                    print("Could not parse to features")
//                }
            }
            

        }
    }
}
