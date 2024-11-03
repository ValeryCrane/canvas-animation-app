import Foundation
import UIKit

protocol CanvasModelInput {
    func viewDidAppear()
    func didAlterCurrentFrame(frame: AnimationFrame)
    func didTapDeleteFrameButton()
    func didTapDeleteAllFramesButton()
    func didTapAddFrameButton()
    func didTapDuplicateFrameButton()
    func didRequestToGenerateFrames(count: Int)
    func didTapFramesButton()
    func didTapPlayButton()
    func didTapPauseButton()
    func didSwipeFromLeftEdge()
    func didSwapFromRightEdge()
    func getAnimationFPS() -> Int
    func didRequestToChangeAnimationFPS(_ fps: Int)
    func didTapExportGIFButton()
}

protocol CanvasModelOutput: UIViewController {
    func getCurrentFrame() -> AnimationFrame
    
    func changeFrame(frame: AnimationFrame, undelyingFrame: AnimationFrame?)
    func startAnimation(frames: [AnimationFrame], fps: Int)
    func endAnimation()
    
    func setIsDeleteButtonEnabled(_ isEnabled: Bool)
    func setIsAddFrameButtonEnabled(_ isEnabled: Bool)
    func setIsFramesButtonEnabled(_ isEnabled: Bool)
    func setIsPlayButtonEnabled(_ isEnabled: Bool)
    func setIsPauseButtonEnabled(_ isEnabled: Bool)
    func setAreCanvasToolsEnabled(_ areEnabled: Bool)
}

final class CanvasModel {
    weak var view: CanvasModelOutput?
    
    private var animationFPS = 30
    
    private var currentFrameIndex: Int = 0
    private var frames: [AnimationFrame] = []
    
    private var currentFrame: AnimationFrame {
        frames[currentFrameIndex]
    }
    
    private var underlyingFrame: AnimationFrame? {
        if currentFrameIndex > 0 {
            return frames[currentFrameIndex - 1]
        } else {
            return nil
        }
    }
}

extension CanvasModel: CanvasModelInput {
    func viewDidAppear() {
        if let view {
            frames = [view.getCurrentFrame()]
            currentFrameIndex = 0
            
            view.setIsDeleteButtonEnabled(frames.count > 1)
        }
    }
    
    func didAlterCurrentFrame(frame: AnimationFrame) {
        frames[currentFrameIndex] = frame
    }
    
    func didTapDeleteFrameButton() {
        guard frames.count > 1 else { return }
        
        frames.remove(at: currentFrameIndex)
        if currentFrameIndex != 0 {
            currentFrameIndex -= 1
        }
        
        view?.setIsDeleteButtonEnabled(frames.count > 1)
        view?.changeFrame(frame: currentFrame, undelyingFrame: underlyingFrame)
    }
    
    func didTapDeleteAllFramesButton() {
        guard let firstFrame = frames.first else { return }
        
        let newFirstFrame = AnimationFrame(size: firstFrame.size, strokesMaxIndex: 0, strokes: [])
        frames = [newFirstFrame]
        currentFrameIndex = 0
        
        view?.setIsDeleteButtonEnabled(frames.count > 1)
        view?.changeFrame(frame: currentFrame, undelyingFrame: underlyingFrame)
    }
    
    func didTapAddFrameButton() {
        guard let lastFrame = frames.last else { return }
        
        let newFrame = AnimationFrame(size: lastFrame.size, strokesMaxIndex: 0, strokes: [])
        frames.append(newFrame)
        currentFrameIndex = frames.count - 1
        
        view?.setIsDeleteButtonEnabled(frames.count > 1)
        view?.changeFrame(frame: currentFrame, undelyingFrame: underlyingFrame)
    }
    
    func didTapDuplicateFrameButton() {
        guard let lastFrame = frames.last else { return }
        
        frames.append(lastFrame)
        currentFrameIndex = frames.count - 1
        
        view?.setIsDeleteButtonEnabled(frames.count > 1)
        view?.changeFrame(frame: currentFrame, undelyingFrame: underlyingFrame)
    }
    
    func didRequestToGenerateFrames(count: Int) {
        // TODO.
    }
    
    func didTapFramesButton() {
        let framesViewController = FramesViewController(
            frames: frames, selectedIndex: currentFrameIndex
        ) { [weak self] selectedFrameIndex in
            if let self, selectedFrameIndex != self.currentFrameIndex {
                self.currentFrameIndex = selectedFrameIndex
                self.view?.changeFrame(
                    frame: currentFrame, undelyingFrame: underlyingFrame
                )
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
        view?.startAnimation(frames: frames, fps: animationFPS)
        
        view?.setIsDeleteButtonEnabled(false)
        view?.setIsAddFrameButtonEnabled(false)
        view?.setIsFramesButtonEnabled(false)
        view?.setIsPlayButtonEnabled(false)
        view?.setIsPauseButtonEnabled(true)
        view?.setAreCanvasToolsEnabled(false)
    }
    
    func didTapPauseButton() {
        currentFrameIndex = frames.count - 1
        view?.changeFrame(frame: currentFrame, undelyingFrame: underlyingFrame)
        view?.endAnimation()
        
        view?.setIsDeleteButtonEnabled(frames.count > 1)
        view?.setIsAddFrameButtonEnabled(true)
        view?.setIsFramesButtonEnabled(true)
        view?.setIsPlayButtonEnabled(true)
        view?.setIsPauseButtonEnabled(false)
        view?.setAreCanvasToolsEnabled(true)
    }
    
    func didSwipeFromLeftEdge() {
        // TODO. Выключать при проигрывании анимации
        guard currentFrameIndex > 0 else { return }
        
        currentFrameIndex -= 1
        view?.changeFrame(frame: currentFrame, undelyingFrame: underlyingFrame)
    }
    
    func didSwapFromRightEdge() {
        // TODO. Выключать при проигрывании анимации
        guard currentFrameIndex + 1 < frames.count else { return }
        
        currentFrameIndex += 1
        view?.changeFrame(frame: currentFrame, undelyingFrame: underlyingFrame)
    }
    
    func getAnimationFPS() -> Int {
        animationFPS
    }
    
    func didRequestToChangeAnimationFPS(_ fps: Int) {
        animationFPS = fps
    }
    
    func didTapExportGIFButton() {
        // TODO.
    }
}
