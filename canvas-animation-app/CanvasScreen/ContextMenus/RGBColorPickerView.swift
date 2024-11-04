import Foundation
import UIKit

protocol RGBColorPickerViewDelegate: AnyObject {
    func rgbColorPickerView(
        _ rgbColorPickerView: RGBColorPickerView, didPickColor color: UIColor
    )
}

extension RGBColorPickerView {
    private enum Constants {
        static let verticalMargins: CGFloat = 16
        static let horizontalMargins: CGFloat = 16
        static let verticalStackViewSpacing: CGFloat = 12
        static let horizontalStackViewSpacing: CGFloat = 20
        
        static let colorViewCornerRadius: CGFloat = 4
    }
}

final class RGBColorPickerView: UIVisualEffectView {
    weak var delegate: RGBColorPickerViewDelegate?
    
    private let redSlider = UISlider()
    private let greenSlider = UISlider()
    private let blueSlider = UISlider()
    
    private let colorView = UIView()
    private let finishImageView = UIImageView(image: .res.checkmark)
    
    init(initialColor: UIColor, delegate: RGBColorPickerViewDelegate? = nil) {
        self.delegate = delegate
        
        super.init(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        
        configure(initialColor: initialColor)
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(initialColor: UIColor) {
        finishImageView.tintColor = .res.tool
        
        redSlider.minimumTrackTintColor = .systemRed
        greenSlider.minimumTrackTintColor = .systemGreen
        blueSlider.minimumTrackTintColor = .systemBlue
        
        [redSlider, greenSlider, blueSlider].forEach { slider in
            slider.minimumValue = 0
            slider.maximumValue = 1
        }
        
        redSlider.value = Float(CIColor(color: initialColor).red)
        greenSlider.value = Float(CIColor(color: initialColor).green)
        blueSlider.value = Float(CIColor(color: initialColor).blue)
        
        redSlider.addTarget(self, action: #selector(didRedSliderChangeValue(_:)), for: .valueChanged)
        greenSlider.addTarget(self, action: #selector(didGreenSliderChangeValue(_:)), for: .valueChanged)
        blueSlider.addTarget(self, action: #selector(didBlueSliderChangeValue(_:)), for: .valueChanged)
        
        updateColorView()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapFinishButton(_:)))
        finishImageView.addGestureRecognizer(tapGestureRecognizer)
        finishImageView.isUserInteractionEnabled = true
    }
    
    private func layout() {
        let horizontalStackView = UIStackView(arrangedSubviews: [colorView, finishImageView])
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = Constants.horizontalStackViewSpacing
        
        let verticalStackView = UIStackView(arrangedSubviews: [redSlider, greenSlider, blueSlider, horizontalStackView])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = Constants.verticalStackViewSpacing
        
        contentView.addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.verticalMargins),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargins),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalMargins),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.verticalMargins)
        ])
        
        colorView.layer.cornerRadius = Constants.colorViewCornerRadius
        colorView.clipsToBounds = true
    }
    
    @objc
    private func didRedSliderChangeValue(_ sender: UISlider) {
        updateColorView()
    }
    
    @objc
    private func didGreenSliderChangeValue(_ sender: UISlider) {
        updateColorView()
    }
    
    @objc
    private func didBlueSliderChangeValue(_ sender: UISlider) {
        updateColorView()
    }
    
    @objc
    private func didTapFinishButton(_ sender: UITapGestureRecognizer) {
        delegate?.rgbColorPickerView(self, didPickColor: .init(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1
        ))
    }
    
    private func updateColorView() {
        colorView.backgroundColor = .init(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1
        )
    }
}
