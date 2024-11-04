import Foundation
import UIKit

final class ToolCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier: String = "ToolCollectionViewCell"
    
    private let imageView = UIImageView()
    private var onTap: (() -> Void)?
    
    override var isSelected: Bool {
        didSet {
            updateTintColor()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = bounds
    }
    
    func setup(image: UIImage, onTap: (() -> Void)? = nil) {
        self.imageView.image = image
    }
    
    private func configure() {
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        updateTintColor()
    }
    
    private func updateTintColor() {
        if isSelected {
            imageView.tintColor = .res.toolSelected
        } else {
            imageView.tintColor = .res.tool
        }
    }
}
