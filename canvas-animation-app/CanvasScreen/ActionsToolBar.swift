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
    
    private let undoButton = CustomToolBarItem(image: .res.rightArrow)
    private let redoButton = CustomToolBarItem(image: .res.leftArrow)
    
    private let deleteButton = CustomToolBarItem(image: .res.bin)
    private let addButton = CustomToolBarItem(image: .res.filePlus)
    private let framesButton = CustomToolBarItem(image: .res.layers)
    
    private let playButton = CustomToolBarItem(image: .res.play)
    private let pauseButton = CustomToolBarItem(image: .res.pause)
    
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
    private func didTapUndoButton(_ sender: CustomToolBarItem) {
        delegate?.actionsToolBarDidTapUndoButton(self)
    }
    
    @objc
    private func didTapRedoButton(_ sender: CustomToolBarItem) {
        delegate?.actionsToolBarDidTapRedoButton(self)
    }
    
    @objc
    private func didTapDeleteButton(_ sender: CustomToolBarItem) {
        delegate?.actionsToolBarDidTapDeleteButton(self)
    }
    
    @objc
    private func didTapAddButton(_ sender: CustomToolBarItem) {
        delegate?.actionsToolBarDidTapAddButton(self)
    }
    
    @objc
    private func didTapFramesButton(_ sender: CustomToolBarItem) {
        delegate?.actionsToolBarDidTapFramesButton(self)
    }
    
    @objc
    private func didTapPlayButton(_ sender: CustomToolBarItem) {
        delegate?.actionsToolBarDidTapPlayButton(self)
    }
    
    @objc
    private func didTapPauseButton(_ sender: CustomToolBarItem) {
        delegate?.actionsToolBarDidTapPauseButton(self)
    }
}
