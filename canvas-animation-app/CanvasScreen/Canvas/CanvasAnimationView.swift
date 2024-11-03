import Foundation
import UIKit

final class CanvasAnimationView: UIView {
    private var fps: Int?
    private var frames: [Frame]?
    
    private var displayLink: CADisplayLink?
    private var startTime: CFTimeInterval?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard
            let fps, let frames, let startTime,
            let context = UIGraphicsGetCurrentContext()
        else {
            return
        }
        
        let currentTime = CACurrentMediaTime()
        let currentFrame = Int((currentTime - startTime) * Double(fps)) % frames.count
        
        for i in 0 ..< frames[currentFrame].strokesMaxIndex {
            frames[currentFrame].strokes[i].draw(inContext: context)
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .clear
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation(frames: [Frame], fps: Int) {
        self.frames = frames
        self.fps = fps
        
        displayLink = .init(target: self, selector: #selector(displayLinkDidFire(_:)))
        startTime = CACurrentMediaTime()
        displayLink?.add(to: .main, forMode: .common)
    }
    
    func endAnimation() {
        displayLink?.isPaused = true
        displayLink?.invalidate()
        
        fps = nil
        frames = nil
        displayLink = nil
        startTime = nil
    }
    
    @objc
    private func displayLinkDidFire(_ sender: CADisplayLink) {
        setNeedsDisplay()
    }
}
