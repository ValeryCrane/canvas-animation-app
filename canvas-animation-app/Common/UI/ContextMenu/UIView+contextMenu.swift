import Foundation
import UIKit

extension UIView {
    func showContextMenu(_ contextMenu: ContextMenu) {
        guard let viewController = getViewController() else { return }
        
        viewController.view.addSubview(contextMenu)
        contextMenu.setupConstraints(
            anchorViewLayoutGuide: createLayoutGuide(),
            screenLayoutGuide: viewController.view.safeAreaLayoutGuide
        )
        
        contextMenu.onAppear { [weak self] in
            self?.contextMenus.append(contextMenu)
        }
    }
    
    func dismissContextMenus() {
        contextMenus.forEach { contextMenu in
            contextMenu.onDismiss {
                contextMenu.removeFromSuperview()
            }
        }
        
        subviews.forEach { subview in
            subview.dismissContextMenus()
        }
    }
    
    private func getViewController() -> UIViewController? {
        var responder: UIResponder? = self.next
        
        while responder != nil {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            responder = responder?.next
        }
        return nil
    }
    
    private func createLayoutGuide() -> UILayoutGuide {
        let layoutGuide = UILayoutGuide()
        addLayoutGuide(layoutGuide)
        
        NSLayoutConstraint.activate([
            layoutGuide.topAnchor.constraint(equalTo: topAnchor),
            layoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor),
            layoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor),
            layoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        return layoutGuide
    }
}

extension UIView {
    private enum AssotiatedKeys {
        static var contextMenus: UInt8 = 0
    }
    
    fileprivate var contextMenus: [ContextMenu] {
        get {
            objc_getAssociatedObject(self, &AssotiatedKeys.contextMenus) as? [ContextMenu] ?? []
        }
        set {
            objc_setAssociatedObject(
                self, &AssotiatedKeys.contextMenus, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}
