import Foundation
import UIKit

extension FrameCollectionViewCell {
    private enum Constants {
        static let indexSpacing: CGFloat = 16
        static let renderViewCornerRadius: CGFloat = 4
    }
}

final class FrameCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "FrameTableViewCell"
    
    static func sizeThatFits(_ size: CGSize, frame: AnimationFrame, index: Int) -> CGSize {
        let estimatedIndexHeight = "\(index)".estimatedHeight(
            withFont: .systemFont(ofSize: 16), width: .greatestFiniteMagnitude
        )
        
        let renderViewMaxSize: CGSize = .init(
            width: size.width,
            height: size.height - Constants.indexSpacing - estimatedIndexHeight
        )
        
        let aspectRatio = frame.size.width / frame.size.height
        
        let renderViewHeight: CGFloat
        let renderViewWidth: CGFloat
        
        if aspectRatio > 1 {
            renderViewHeight = min(renderViewMaxSize.width / aspectRatio, renderViewMaxSize.height)
            renderViewWidth = renderViewHeight * aspectRatio
        } else {
            renderViewWidth = min(renderViewMaxSize.width, renderViewMaxSize.height * aspectRatio)
            renderViewHeight = renderViewWidth / aspectRatio
        }
        
        return .init(
            width: renderViewWidth,
            height: renderViewHeight + Constants.indexSpacing + estimatedIndexHeight
        )
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundImageView.layer.borderWidth = isSelected ? 2 : 0
        }
    }
    
    private let renderView = BasicRenderView()
    private let backgroundImageView = UIImageView(image: .res.canvasBackground)
    private let indexLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(frame: AnimationFrame, index: Int) {
        renderView.renderFrame = frame
        indexLabel.text = "\(index)"
    }
    
    private func configure() {
        backgroundImageView.layer.borderColor = UIColor.res.toolSelected.cgColor
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.layer.cornerRadius = Constants.renderViewCornerRadius
        backgroundImageView.clipsToBounds = true
        
        indexLabel.font = .systemFont(ofSize: 16)
    }
    
    private func layout() {
        contentView.addSubview(backgroundImageView)
        backgroundImageView.addSubview(renderView)
        contentView.addSubview(indexLabel)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        renderView.translatesAutoresizingMaskIntoConstraints = false
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            renderView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor),
            renderView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor),
            renderView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor),
            renderView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),
            
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            indexLabel.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor),
            indexLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            indexLabel.topAnchor.constraint(
                equalTo: renderView.bottomAnchor, constant: Constants.indexSpacing
            )
        ])
    }
}
