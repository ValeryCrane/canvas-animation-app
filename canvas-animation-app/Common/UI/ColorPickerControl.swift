import Foundation
import UIKit

extension ColorPickerControl {
    private enum Constants {
        static let borderWidth: CGFloat = 1.5
    }
}

final class ColorPickerControl: UIControl {
    var color: UIColor {
        didSet {
            iconLayer.backgroundColor = color.cgColor
        }
    }
    
    override var isSelected: Bool {
        didSet {
            updateBorderColor()
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1 : 0.5
        }
    }
    
    private let iconLayer = CALayer()
    
    init(color: UIColor) {
        self.color = color
        
        super.init(frame: .zero)
        
        layer.addSublayer(iconLayer)
        iconLayer.backgroundColor = color.cgColor
        iconLayer.borderWidth = Constants.borderWidth
        updateBorderColor()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapGesture(_:)))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        updateBorderColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let minimalDimension = min(bounds.height, bounds.width)
        iconLayer.frame = .init(
            x: (bounds.width - minimalDimension) / 2,
            y: (bounds.height - minimalDimension) / 2,
            width: minimalDimension,
            height: minimalDimension
        )
        
        iconLayer.cornerRadius = minimalDimension / 2
    }
    
    @objc
    private func onTapGesture(_ sender: UITapGestureRecognizer) {
        if isEnabled {
            sendActions(for: .touchUpInside)
        }
    }
    
    private func updateBorderColor() {
        if isSelected {
            iconLayer.borderColor = UIColor.res.toolSelected.cgColor
        } else {
            iconLayer.borderColor = UIColor.res.tool.cgColor
        }
    }
}
