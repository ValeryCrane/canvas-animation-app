import Foundation
import UIKit

final class BasicRenderView: UIView {
    var renderFrame: AnimationFrame? {
        didSet {
            aspectRatioConstraint?.isActive = false
            aspectRatioConstraint = nil
            
            if let renderFrame {
                aspectRatioConstraint = widthAnchor.constraint(
                    equalTo: heightAnchor,
                    multiplier: renderFrame.size.width / renderFrame.size.height
                )
                aspectRatioConstraint?.isActive = true
                
                setNeedsLayout()
            }
            
            setNeedsDisplay()
        }
    }
    
    private var aspectRatioConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard 
            let renderFrame,
            let context = UIGraphicsGetCurrentContext()
        else { return }
        
        context.scaleBy(
            x: bounds.width / renderFrame.size.width,
            y: bounds.height / renderFrame.size.height
        )
        for i in 0 ..< renderFrame.strokesMaxIndex {
            renderFrame.strokes[i].draw(inContext: context)
        }
    }
}
