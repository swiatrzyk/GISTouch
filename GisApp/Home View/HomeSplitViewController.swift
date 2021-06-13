
import UIKit

class HomeSplitViewController: UISplitViewController {
    
    enum Constants {
        static let moreWidth: CGFloat = 320.0
        static let animationDuration: TimeInterval = 0.3
    }
    
    let moreVCPlaceholder = UIView()
    private var panGestureRecognizer: UIPanGestureRecognizer? = nil
    private(set) var xTranslation: CGFloat? = nil
    private var xPosition: CGFloat? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = false
        setupMoreViewLayout()
        setupMoreViewGestureHandling()
    }
    
    private func setupMoreViewLayout() {
        view.addSubview(moreVCPlaceholder)
        moreVCPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moreVCPlaceholder.widthAnchor.constraint(equalToConstant: Constants.moreWidth),
            view.topAnchor.constraint(equalTo: moreVCPlaceholder.topAnchor),
            view.bottomAnchor.constraint(equalTo: moreVCPlaceholder.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: moreVCPlaceholder.leadingAnchor),
        ])
    }
    
    private func setupMoreViewGestureHandling() {
        let panGestureRecognizer = UIPanGestureRecognizer()
        self.panGestureRecognizer = panGestureRecognizer
        panGestureRecognizer.addTarget(self, action: #selector(panGestureRecognized(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
        
        xTranslation = Constants.moreWidth
    }
    
    @objc private func panGestureRecognized(_ sender: UIPanGestureRecognizer) {
        
        if UIDevice.current.userInterfaceIdiom == .phone,
           UIWindow.isPortrait {
            return
        }
        
        switch sender.state {
        case .began:
            xPosition = xTranslation
            break
        case .changed:
            guard let initial = xPosition else {
                return
            }
            let x = sender.translation(in: view).x
            let translation: CGFloat
            if initial + x < 0 {
                translation = 0.0
            }
            else if initial + x > Constants.moreWidth {
                translation = Constants.moreWidth
            }
            else {
                translation = initial+x
            }
            updateTranslation(translation)
        case .ended, .cancelled, .failed:
            xPosition = nil
            let translation = xTranslation! > Constants.moreWidth/2 ? Constants.moreWidth : 0.0
            UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
                self?.updateTranslation(translation)
            }
        default:
            break
        }
    }
}

extension HomeSplitViewController {
    
    func updateTranslation(_ translation: CGFloat) {
        xTranslation = translation
        view.transform = CGAffineTransform(translationX: translation-Constants.moreWidth, y: 0)
    }
    
    func showMoreVC(_ show: Bool, animated: Bool) {
        UIView.animate(withDuration: animated ? Constants.animationDuration : 0.0) { [weak self] in
            self?.updateTranslation(show ? 0 : Constants.moreWidth)
        }
    }
}

