import Foundation
import UIKit

protocol ActionsToolBarDelegate: AnyObject {
    func actionsToolBarDidTapUndoButton(_ actionsToolBar: ActionsToolBar)
    func actionsToolBarDidTapRedoButton(_ actionsToolBar: ActionsToolBar)
    func actionsToolBarDidTapDeleteButton(_ actionsToolBar: ActionsToolBar)
    func actionsToolBarDidTapAddButton(_ actionsToolBar: ActionsToolBar)
    func actionsToolBarDidTapFramesButton(_ actionsToolBar: ActionsToolBar)
    func actionsToolBarDidTapPlayButton(_ actionsToolBar: ActionsToolBar)
    func actionsToolBarDidTapPauseButton(_ actionsToolBar: ActionsToolBar)
}

final class ActionsToolBar: CustomToolBar {
    weak var delegate: ActionsToolBarDelegate?
    
    private let undoButton = ToolControl(image: .res.rightArrow)
    private let redoButton = ToolControl(image: .res.leftArrow)
    
    private let deleteButton = ToolControl(image: .res.bin)
    private let addButton = ToolControl(image: .res.filePlus)
    private let framesButton = ToolControl(image: .res.layers)
    
    private let playButton = ToolControl(image: .res.play)
    private let pauseButton = ToolControl(image: .res.pause)
    
    init(delegate: ActionsToolBarDelegate? = nil) {
        self.delegate = delegate
        
        super.init(
            leadingItems: [undoButton, redoButton],
            centerItems: [deleteButton, addButton, framesButton],
            trailingItems: [playButton, pauseButton]
        )
        
        configureButtons()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setIsUndoButtonEnabled(_ isEnabled: Bool) {
        undoButton.isEnabled = isEnabled
    }
    
    func setIsRedoButtonEnabled(_ isEnabled: Bool) {
        redoButton.isEnabled = isEnabled
    }
    
    func setIsPlayButtonEnabled(_ isEnabled: Bool) {
        playButton.isEnabled = isEnabled
    }
    
    func setIsPauseButtonEnabled(_ isEnabled: Bool) {
        pauseButton.isEnabled = isEnabled
    }
    
    private func configureButtons() {
        undoButton.addTarget(self, action: #selector(didTapUndoButton(_:)), for: .touchUpInside)
        redoButton.addTarget(self, action: #selector(didTapRedoButton(_:)), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton(_:)), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(didTapAddButton(_:)), for: .touchUpInside)
        framesButton.addTarget(self, action: #selector(didTapFramesButton(_:)), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(didTapPlayButton(_:)), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(didTapPauseButton(_:)), for: .touchUpInside)
    }
    
    @objc
    private func didTapUndoButton(_ sender: ToolControl) {
        delegate?.actionsToolBarDidTapUndoButton(self)
    }
    
    @objc
    private func didTapRedoButton(_ sender: ToolControl) {
        delegate?.actionsToolBarDidTapRedoButton(self)
    }
    
    @objc
    private func didTapDeleteButton(_ sender: ToolControl) {
        delegate?.actionsToolBarDidTapDeleteButton(self)
    }
    
    @objc
    private func didTapAddButton(_ sender: ToolControl) {
        delegate?.actionsToolBarDidTapAddButton(self)
    }
    
    @objc
    private func didTapFramesButton(_ sender: ToolControl) {
        delegate?.actionsToolBarDidTapFramesButton(self)
    }
    
    @objc
    private func didTapPlayButton(_ sender: ToolControl) {
        delegate?.actionsToolBarDidTapPlayButton(self)
    }
    
    @objc
    private func didTapPauseButton(_ sender: ToolControl) {
        delegate?.actionsToolBarDidTapPauseButton(self)
    }
}
