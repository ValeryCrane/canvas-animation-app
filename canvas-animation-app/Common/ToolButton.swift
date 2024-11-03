import Foundation
import UIKit

final class ToolButton: UIButton {
    private let iconView = UIImageView()
    
    override var isEnabled: Bool {
        didSet {
            updateTintColor()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            updateTintColor()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        iconView.image?.size ?? .zero
    }
    
    init(image: UIImage) {
        self.iconView.image = image
        
        super.init(frame: .zero)
        
        addSubview(iconView)
        updateTintColor()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconView.frame = bounds
    }
    
    private func updateTintColor() {
        if isEnabled {
            if isSelected {
                iconView.tintColor = .res.toolSelected
            } else {
                iconView.tintColor = .res.tool
            }
        } else {
            iconView.tintColor = .res.toolDisabled
        }
    }
}
