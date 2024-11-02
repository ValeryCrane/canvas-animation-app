import Foundation
import UIKit

final class CanvasBackgroundView: UIView {
    private let imageView = UIImageView(image: .res.canvasBackground)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = bounds
    }
    
    private func setup() {
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
    }
}
