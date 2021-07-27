
import UIKit
import GEOSwift

enum ShapeFileExtension {
    case shp
    case prj
    case sbn
    case sbx
    case shx
    
    
}

class FirstColumnViewController: UITableViewController {
    
    var detailViewController: SecondColumnViewController? = nil
    
    var localFiles = ["Kantone", "states", "DOKMPARCELA_P"]
    
//    lazy var documentsBrwoserVC: UIDocumentBrowserViewController = {
//        let documentsBrwoserVC = UIDocumentBrowserViewController()
//        documentsBrwoserVC.allowsPickingMultipleItems = true
//        documentsBrwoserVC.delegate = self
//        documentsBrwoserVC.modalPresentationStyle = .fullScreen
//        return documentsBrwoserVC
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.setRightBarButton(addButton, animated: false)
        if let split = splitViewController {
            var controllers = split.viewControllers
            split.viewControllers.append(SecondColumnViewController())
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? SecondColumnViewController
            detailViewController?.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            detailViewController?.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    @objc func insertNewObject(_ sender: Any) {
//        self.present(documentsBrwoserVC, animated: true, completion: nil)
    }
    
    // MARK: - Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localFiles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = localFiles[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let localFileName = localFiles[indexPath.row]
        if let localFilePath = Bundle.main.resourcePath?.appending("/" + localFileName) {
            detailViewController?.loadFile(with: localFilePath)
        }

//        [[MultiPolygonOverlay alloc] initWithLocalShpFile:[resourcePath stringByAppendingPathComponent:@"states"]];
//        if let shapefileReader = try? ShapefileReader(path:localFileName) {
//            let shapes = shapefileReader.shp.allShapes()
//        }
    }
}

//extension FirstColumnViewController: UIDocumentBrowserViewControllerDelegate {
//    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
//        self.documentsBrwoserVC.dismiss(animated: true, completion: nil)
//        documentURLs.forEach { url in
//            let fileName = url.lastPathComponent
//            let decoder = JSONDecoder()
//            if let data = try? Data(contentsOf: url),
//               let geoJSON = try? decoder.decode(GeoJSON.self, from: data) {
//
////                objects.insert((fileName, geoJSON), at: 0)
//                let indexPath = IndexPath(row: 0, section: 0)
//                tableView.insertRows(at: [indexPath], with: .automatic)
//                detailViewController?.geoData = geoJSON
//                //                switch geoJSON {
//                //                case .feature(let feature):
//                //                    let geometry = feature.geometry
//                //                case .featureCollection(let featureCollection):
//                //                    break
//                //                case .geometry(let geometry):
//                //                    break
//                //                default:
//                //                    print("Could not parse to features")
//                //                }
//            }
//
//
//        }
//    }
//}
