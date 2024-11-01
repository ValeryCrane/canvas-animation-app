import Foundation
import UIKit

protocol ContextMenu: UIView {
    func setupConstraints(
        anchorViewLayoutGuide: UILayoutGuide,
        screenLayoutGuide: UILayoutGuide
    )
    
    func layout(
        anchorViewFrame: CGRect,
        screenBounds: CGRect
    )
    
    func onAppear(completion: (() -> Void)?)
    func onDismiss(completion: (() -> Void)?)
}

extension ContextMenu {
    func setupConstraints(
        anchorViewLayoutGuide: UILayoutGuide,
        screenLayoutGuide: UILayoutGuide
    ) {
        // Method is optional.
    }
    
    func layout(
        anchorViewFrame: CGRect,
        screenBounds: CGRect
    ) {
        // Method is optional.
    }
    
    func onAppear(completion: (() -> Void)?) {
        completion?()
    }
    
    func onDismiss(completion: (() -> Void)?) {
        completion?()
    }
}
