import Foundation
import UIKit

protocol CanvasModelInput {
    func viewDidAppear()
    func didUpdateCurrentFrame(frame: Frame)
    func didTapAddButton()
    func didTapDeleteButton()
    func didTapFramesButton()
    func didTapPlayButton()
}

protocol CanvasModelOutput: UIViewController {
    func getCurrentFrame() -> Frame
    
    func changeFrame(frame: Frame)
    func setDeleteButtonIsEnabled(_ isEnabled: Bool)
    func startAnimation(frames: [Frame], fps: Int)
}

final class CanvasModel: CanvasModelInput {
    weak var view: CanvasModelOutput?
    
    var currentFrame: Int = 0
    var frames: [Frame] = [] {
        didSet {
            view?.setDeleteButtonIsEnabled(frames.count > 1)
        }
    }
    
    func didUpdateCurrentFrame(frame: Frame) {
        frames[currentFrame] = frame
    }
    
    func viewDidAppear() {
        if let view {
            frames = [view.getCurrentFrame()]
            currentFrame = 0
        }
    }
    
    func didTapAddButton() {
        guard let lastFrame = frames.last else { return }
        
        let newFrame = Frame(size: lastFrame.size, strokesMaxIndex: 0, strokes: [])
        frames.append(newFrame)
        currentFrame = frames.count - 1
        
        view?.changeFrame(frame: frames[currentFrame])
    }
    
    func didTapDeleteButton() {
        guard frames.count > 1 else { return }
        
        frames.remove(at: currentFrame)
        if currentFrame != 0 {
            currentFrame -= 1
        }
        
        view?.changeFrame(frame: frames[currentFrame])
    }
    
    func didTapFramesButton() {
        let framesViewController = FramesViewController(
            frames: frames, selectedIndex: currentFrame
        ) { [weak self] selectedFrame in
            if let self, selectedFrame != self.currentFrame {
                self.currentFrame = selectedFrame
                view?.changeFrame(frame: self.frames[self.currentFrame])
            }
        }
        
        if let sheet = framesViewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
            
        view?.present(framesViewController, animated: true)
    }
    
    func didTapPlayButton() {
        view?.startAnimation(frames: frames, fps: 30)
    }
}
