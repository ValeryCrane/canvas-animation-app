import Foundation
import UIKit

protocol FPSContextMenuDelegate: AnyObject {
    func fpsContextMenu(_ fpsContextMenu: FPSContextMenu, didChangeFPS fps: Int)
}

extension FPSContextMenu {
    private enum Constants {
        static let horizontalMargin: CGFloat = 16
        static let verticalMargin: CGFloat = 16
        
        static let labelWidth: CGFloat = 64
        static let stackViewSpacing: CGFloat = 8
        static let horizontalParentViewOffsets: CGFloat = 32
        static let cornerRadius: CGFloat = 4
        
        static let alphaAnimationDuration: Double = 0.2
    }
}

final class FPSContextMenu: UIVisualEffectView {
    weak var delegate: FPSContextMenuDelegate?
    
    private let valueLabel = UILabel()
    private let slider = UISlider()
    private let finishImageView = UIImageView(image: .res.checkmark)
    
    private var fps: Int
    
    init(initialFPS: Int, delegate: FPSContextMenuDelegate? = nil) {
        self.fps = initialFPS
        self.delegate = delegate
        
        super.init(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        
        configure()
        layout()
        alpha = 0
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        valueLabel.text = "FPS: \(fps)"
        valueLabel.font = .systemFont(ofSize: 16)
        valueLabel.textColor = .white
        finishImageView.tintColor = .white
        slider.minimumValue = 5
        slider.maximumValue = 60
        slider.value = Float(fps)
        slider.addTarget(self, action: #selector(didSliderChangeValue(_:)), for: .valueChanged)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onFinishButtonTapped(_:)))
        finishImageView.addGestureRecognizer(tapGestureRecognizer)
        finishImageView.isUserInteractionEnabled = true
    }
    
    private func layout() {
        let stackView = UIStackView(arrangedSubviews: [valueLabel, slider, finishImageView])
        stackView.axis = .horizontal
        stackView.spacing = Constants.stackViewSpacing
        stackView.alignment = .center
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.verticalMargin),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalMargin),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.verticalMargin),
            
            valueLabel.widthAnchor.constraint(equalToConstant: Constants.labelWidth)
        ])
        
        layer.cornerRadius = Constants.cornerRadius
        clipsToBounds = true
    }
    
    @objc
    private func didSliderChangeValue(_ slider: UISlider) {
        fps = Int(slider.value)
        valueLabel.text = "FPS: \(Int(slider.value))"
    }
    
    @objc
    private func onFinishButtonTapped(_ sender: UITapGestureRecognizer) {
        delegate?.fpsContextMenu(self, didChangeFPS: fps)
    }
}

extension FPSContextMenu: ContextMenu {
    func setupConstraints(anchorViewLayoutGuide: UILayoutGuide, screenLayoutGuide: UILayoutGuide) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(
                equalTo: screenLayoutGuide.leadingAnchor, constant: Constants.horizontalParentViewOffsets
            ),
            trailingAnchor.constraint(
                equalTo: screenLayoutGuide.trailingAnchor, constant: -Constants.horizontalParentViewOffsets
            ),
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
