
import UIKit
import MapKit
import GEOSwift
import GEOSwiftMapKit

extension SecondColumnViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polygonsView = MultiPolygonRenderer(overlay: overlay)
        polygonsView.fillColor = .clear
        polygonsView.strokeColor = UIColor.blue.withAlphaComponent(0.8)
        polygonsView.lineWidth = 1
        return polygonsView
    }
}

class SecondColumnViewController: UIViewController {
    
    var thirdColumnViewController: ThirdColumnViewController? = nil
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail
            }
        }
    }

    var detailItem: String? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        mapView.delegate = self
        let moreButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(more(_:)))
        navigationItem.rightBarButtonItem = moreButton
        
        view.clipsToBounds = false
        navigationController?.view.clipsToBounds = false
        navigationController?.view.subviews.forEach({ $0.clipsToBounds = false })
        
        thirdColumnViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ThirdColumnViewController")
        
        if traitCollection.horizontalSizeClass == .regular {
            addMoreToSplitView()
        }
    }
    
    @objc func more(_ sender: Any) {
        guard let vc = thirdColumnViewController else { return }
        guard let split = splitViewController as? HomeSplitViewController else {
            return
        }
        if traitCollection.horizontalSizeClass == .compact {
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            split.showMoreVC(!isMoreVCVisible, animated: true)
        }
    }
    
    func loadFile(with filePath: String) {
        let multiPolygonOverlay = MultiPolygonOverlay(with: filePath)
        mapView.addOverlay(multiPolygonOverlay)
    }
}

extension SecondColumnViewController {
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        guard let split = splitViewController as? HomeSplitViewController,
              traitCollection.horizontalSizeClass != newCollection.horizontalSizeClass else {
            return
        }

        switch newCollection.horizontalSizeClass {
        case .regular:
            let moreVisible = navigationController?.topViewController == thirdColumnViewController
            if moreVisible {
                navigationController?.popViewController(animated: false)
            }
            
            addMoreToSplitView()
            
            if moreVisible {
                split.showMoreVC(true, animated: false)
            }
        case .compact:
            let moreVisible = isMoreVCVisible
            removeMoreFromSplitView()
            if let vc = thirdColumnViewController, moreVisible {
                navigationController?.pushViewController(vc, animated: false)
            }
        default:
            break
        }
    }
}

extension SecondColumnViewController {
    
    var isMoreVCVisible: Bool {
        
        guard let split = splitViewController as? HomeSplitViewController else {
            return false
        }
        return traitCollection.horizontalSizeClass == .regular && split.xTranslation == 0
    }
    
    func addMoreToSplitView() {
        guard let split = splitViewController as? HomeSplitViewController,
              let moreVC = thirdColumnViewController else {
            return
        }
        
        moreVC.view.translatesAutoresizingMaskIntoConstraints = false
        split.addChild(moreVC)
        split.moreVCPlaceholder.addSubview(moreVC.view)
        
        NSLayoutConstraint.activate([
            split.moreVCPlaceholder.topAnchor.constraint(equalTo: moreVC.view.topAnchor),
            split.moreVCPlaceholder.bottomAnchor.constraint(equalTo: moreVC.view.bottomAnchor),
            split.moreVCPlaceholder.leadingAnchor.constraint(equalTo: moreVC.view.leadingAnchor),
            split.moreVCPlaceholder.trailingAnchor.constraint(equalTo: moreVC.view.trailingAnchor),
        ])
    }
    
    func removeMoreFromSplitView() {
        guard let moreVC = thirdColumnViewController,
              let split = splitViewController as? HomeSplitViewController,
              split.children.contains(moreVC) else {
            return
        }

        split.showMoreVC(false, animated: false)
        moreVC.removeFromParent()
        moreVC.view.removeFromSuperview()
        moreVC.view.translatesAutoresizingMaskIntoConstraints = true
    }
}
