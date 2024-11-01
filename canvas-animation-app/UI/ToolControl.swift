import Foundation
import UIKit

final class ToolControl: UIControl {
    private let imageView = UIImageView()
    
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
        imageView.image?.size ?? .zero
    }
    
    init(image: UIImage) {
        self.imageView.image = image
        
        super.init(frame: .zero)
        
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(onTapGesture(_:))
        )
        
        addGestureRecognizer(tapGestureRecognizer)
        addSubview(imageView)
        updateTintColor()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = bounds
    }
    
    @objc
    private func onTapGesture(_ sender: UITapGestureRecognizer) {
        if isEnabled {
            sendActions(for: .touchUpInside)
        }
    }
    
    private func updateTintColor() {
        if isEnabled {
            if isSelected {
                imageView.tintColor = .res.toolSelected
            } else {
                imageView.tintColor = .res.tool
            }
        } else {
            imageView.tintColor = .res.toolDisabled
        }
    }
}
