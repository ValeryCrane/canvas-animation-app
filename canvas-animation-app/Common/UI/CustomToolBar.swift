import Foundation
import UIKit

private extension CustomToolBar {
    private enum Constants {
        static let leadingStackViewSpacing: CGFloat = 8
        static let centerStackViewSpacing: CGFloat = 16
        static let trailingStackViewSpacing: CGFloat = 16
    }
}

class CustomToolBar: UIView {
    private let leadingStackView = UIStackView()
    private let centerStackView = UIStackView()
    private let trailingStackView = UIStackView()
    
    override var intrinsicContentSize: CGSize {
        .init(
            width: UIView.noIntrinsicMetric,
            height: max(
                leadingStackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height,
                centerStackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height,
                trailingStackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            )
        )
    }
    
    init(
        leadingItems: [UIControl] = [],
        centerItems: [UIControl] = [],
        trailingItems: [UIControl] = []
    ) {
        super.init(frame: .zero)
        
        leadingItems.forEach {
            leadingStackView.addArrangedSubview($0)
        }
        
        centerItems.forEach {
            centerStackView.addArrangedSubview($0)
        }
        
        trailingItems.forEach {
            trailingStackView.addArrangedSubview($0)
        }
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        [leadingStackView, centerStackView, trailingStackView].forEach { stackView in
            stackView.axis = .horizontal
            stackView.alignment = .center
        }
        
        leadingStackView.spacing = Constants.leadingStackViewSpacing
        centerStackView.spacing = Constants.centerStackViewSpacing
        trailingStackView.spacing = Constants.trailingStackViewSpacing
    }
    
    private func layout() {
        [leadingStackView, centerStackView, trailingStackView].forEach { stackView in
            addSubview(stackView)
            stackView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            leadingStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            leadingStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            leadingStackView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor),
            
            centerStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            centerStackView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor),
            
            trailingStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            trailingStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            trailingStackView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor)
        ])
    }
}
