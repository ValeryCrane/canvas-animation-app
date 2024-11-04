import Foundation
import QuartzCore

protocol FrameGenerator {
    func generate(frameCount: Int, frameSize: CGSize) -> [AnimationFrame]
}
