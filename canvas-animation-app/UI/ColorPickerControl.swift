import Foundation
import UIKit

extension ColorPickerControl {
    private enum Constants {
        static let selectedBorderWidth: CGFloat = 1.5
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
            if isSelected {
                iconLayer.borderWidth = Constants.selectedBorderWidth
            } else {
                iconLayer.borderWidth = 0
            }
        }
    }
    
    private let iconLayer = CALayer()
    
    init(color: UIColor) {
        self.color = color
        
        super.init(frame: .zero)
        
        layer.addSublayer(iconLayer)
        iconLayer.backgroundColor = color.cgColor
        iconLayer.borderColor = UIColor.res.toolSelected.cgColor
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapGesture(_:)))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
}
