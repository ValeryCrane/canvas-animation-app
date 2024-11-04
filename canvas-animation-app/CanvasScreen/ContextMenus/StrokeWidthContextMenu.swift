import Foundation
import UIKit

protocol StrokeWidthContextMenuDelegate: AnyObject {
    func strokeWidthContextMenu(
        _ strokeWidthCobtextMenu: StrokeWidthContextMenu,
        didChangeStrokeWidth strokeWidth: CGFloat
    )
}

extension StrokeWidthContextMenu {
    private enum Constants {
        static let horizontalMargin: CGFloat = 16
        static let verticalMargin: CGFloat = 16
        
        static let sliderHeight: CGFloat = 20
        static let sliderWidth: CGFloat = 192
        
        static let cornerRadius: CGFloat = 4
        
        static let alphaAnimationDuration: Double = 0.2
    }
}

final class StrokeWidthContextMenu: UIVisualEffectView {
    weak var delegate: StrokeWidthContextMenuDelegate?
    
    private let slider = UISlider()
    
    init(
        initialStrokeWidth: CGFloat,
        minimumStrokeWidth: CGFloat,
        maximumStrokeWidth: CGFloat,
        delegate: StrokeWidthContextMenuDelegate? = nil
    ) {
        self.delegate = delegate
        
        super.init(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        
        configure(
            initialStrokeWidth: initialStrokeWidth,
            minimumStrokeWidth: minimumStrokeWidth,
            maximumStrokeWidth: maximumStrokeWidth
        )
        layout()
        alpha = 0
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(
        initialStrokeWidth: CGFloat,
        minimumStrokeWidth: CGFloat,
        maximumStrokeWidth: CGFloat
    ) {
        slider.semanticContentAttribute = .forceRightToLeft
        slider.setThumbImage(.res.strokeSliderThumb, for: .normal)
        slider.setMaximumTrackImage(.res.strokeSliderTrack, for: .normal)
        slider.setMinimumTrackImage(.res.strokeSliderTrack, for: .normal)
        
        slider.minimumValue = Float(minimumStrokeWidth)
        slider.maximumValue = Float(maximumStrokeWidth)
        slider.value = Float(initialStrokeWidth)
        
        slider.addTarget(self, action: #selector(onSliderValueChanged(_:)), for: .valueChanged)
    }
    
    private func layout() {
        contentView.addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.verticalMargin),
            slider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            slider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalMargin),
            slider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.verticalMargin),
            
            slider.widthAnchor.constraint(equalToConstant: Constants.sliderWidth),
            slider.heightAnchor.constraint(equalToConstant: Constants.sliderHeight)
        ])
        
        layer.cornerRadius = Constants.cornerRadius
        clipsToBounds = true
    }
    
    @objc
    private func onSliderValueChanged(_ sender: UISlider) {
        delegate?.strokeWidthContextMenu(self, didChangeStrokeWidth: CGFloat(slider.value))
    }
}

extension StrokeWidthContextMenu: ContextMenu {
    func setupConstraints(anchorViewLayoutGuide: UILayoutGuide, screenLayoutGuide: UILayoutGuide) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: screenLayoutGuide.centerXAnchor),
            bottomAnchor.constraint(equalTo: anchorViewLayoutGuide.topAnchor, constant: -16)
        ])
    }
    
    func onAppear(completion: (() -> Void)?) {
        UIView.animate(withDuration: Constants.alphaAnimationDuration) {
            self.alpha = 1
        } completion: { _ in
            completion?()
        }
    }
    
    func onDismiss(completion: (() -> Void)?) {
        UIView.animate(withDuration: Constants.alphaAnimationDuration) {
            self.alpha = 0
        } completion: { _ in
            completion?()
        }
    }
}
