import Foundation
import UIKit

fileprivate var loadingViewControllerAssociationKey: UInt8 = 0

extension UIViewController {
    
    private var loadingViewController: UIViewController? {
        get {
            return objc_getAssociatedObject(self, &loadingViewControllerAssociationKey) as? UIViewController
        }
        set {
            objc_setAssociatedObject(
                self,
                &loadingViewControllerAssociationKey,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    func startLoader() {
        guard self.loadingViewController == nil else { return }
        
        let loadingViewController = LoadingViewController()
        loadingViewController.modalPresentationStyle = .overCurrentContext
        self.loadingViewController = loadingViewController
        present(loadingViewController, animated: false)
    }
    
    func stopLoader() {
        loadingViewController?.dismiss(animated: false)
        loadingViewController = nil
    }
}
