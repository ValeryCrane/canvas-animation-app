import Foundation
import UIKit

protocol ActionsToolBarDelegate: AnyObject {
    func actionsToolBarDidTapUndoButton(_ actionsToolBar: ActionsToolBar)
    func actionsToolBarDidTapRedoButton(_ actionsToolBar: ActionsToolBar)
    func actionsToolBarDidTapDeleteFrameButton(_ actionsToolBar: ActionsToolBar)
    func actionsToolBarDidTapDeleteAllFramesButton(_ actionsToolBar: ActionsToolBar)
    func actionsToolBarDidTapAddFrameButton(_ actionsToolBar: ActionsToolBar)
    func actionsToolBarDidTapDuplicateFrameButton(_ actionsToolBar: ActionsToolBar)
    func actionsToolBarDidTapGenerateFramesButton(_ actionsToolBar: ActionsToolBar)
    func actionsToolBarDidTapFramesButton(_ actionsToolBar: ActionsToolBar)
    func actionsToolBarDidTapPlayButton(_ actionsToolBar: ActionsToolBar)
    func actionsToolBarDidTapPauseButton(_ actionsToolBar: ActionsToolBar)
    func actionsToolBarDidTapChangeFPSButton(_ actionsToolBar: ActionsToolBar)
}

final class ActionsToolBar: CustomToolBar {
    weak var delegate: ActionsToolBarDelegate?
    
    private let undoButton = ToolButton(image: .res.rightArrow)
    private let redoButton = ToolButton(image: .res.leftArrow)
    
    private let deleteButton = ToolButton(image: .res.bin)
    private let addButton = ToolButton(image: .res.filePlus)
    private let framesButton = ToolButton(image: .res.layers)
    
    private let playButton = ToolButton(image: .res.play)
    private let pauseButton = ToolButton(image: .res.pause)
    
    init(delegate: ActionsToolBarDelegate? = nil) {
        self.delegate = delegate
        
        super.init(
            leadingItems: [undoButton, redoButton],
            centerItems: [deleteButton, addButton, framesButton],
            trailingItems: [playButton, pauseButton]
        )
        
        configureButtons()
        configureDeleteButtonMenu()
        configureAddFrameButtonMenu()
        configurePlayButtonMenu()
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
    
    func setIsDeleteFrameButtonEnabled(_ isEnabled: Bool) {
        deleteButton.isEnabled = isEnabled
    }
    
    func setIsAddFrameButtonEnabled(_ isEnabled: Bool) {
        addButton.isEnabled = isEnabled
    }
    
    func setIsFramesButtonEnabled(_ isEnabled: Bool) {
        framesButton.isEnabled = isEnabled
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
    
    private func configureDeleteButtonMenu() {
        let deleteFrameAction = UIAction(title: "Удалить кадр") { [weak self] _ in
            if let self {
                self.delegate?.actionsToolBarDidTapDeleteFrameButton(self)
            }
        }
        
        let deleteAllFramesAction = UIAction(title: "Удалить все кадры", attributes: .destructive) { [weak self] _ in
            if let self {
                self.delegate?.actionsToolBarDidTapDeleteAllFramesButton(self)
            }
        }
        
        deleteButton.menu = UIMenu(children: [deleteFrameAction, deleteAllFramesAction])
    }
    
    private func configureAddFrameButtonMenu() {
        let addFrameAction = UIAction(title: "Добавить кадр") { [weak self] _ in
            if let self {
                self.delegate?.actionsToolBarDidTapAddFrameButton(self)
            }
        }
        
        let duplicateFrameAction = UIAction(title: "Продублировать текущий кадр") { [weak self] _ in
            if let self {
                self.delegate?.actionsToolBarDidTapDuplicateFrameButton(self)
            }
        }
        
        let generateFramesAction = UIAction(title: "Сгенерировать кадры") { [weak self] _ in
            if let self {
                self.delegate?.actionsToolBarDidTapGenerateFramesButton(self)
            }
        }
        
        addButton.menu = UIMenu(children: [addFrameAction, duplicateFrameAction, generateFramesAction])
    }
    
    private func configurePlayButtonMenu() {
        let playAction = UIAction(title: "Запустить анимацию") { [weak self] _ in
            if let self {
                self.delegate?.actionsToolBarDidTapPlayButton(self)
            }
        }
        
        let changeFPSButton = UIAction(title: "Изменить скорость анимации") { [weak self] _ in
            if let self {
                self.delegate?.actionsToolBarDidTapChangeFPSButton(self)
            }
        }
        
        playButton.menu = UIMenu(children: [playAction, changeFPSButton])
    }
    
    @objc
    private func didTapUndoButton(_ sender: ToolButton) {
        delegate?.actionsToolBarDidTapUndoButton(self)
    }
    
    @objc
    private func didTapRedoButton(_ sender: ToolButton) {
        delegate?.actionsToolBarDidTapRedoButton(self)
    }
    
    @objc
    private func didTapDeleteButton(_ sender: ToolButton) {
        delegate?.actionsToolBarDidTapDeleteFrameButton(self)
    }
    
    @objc
    private func didTapAddButton(_ sender: ToolButton) {
        delegate?.actionsToolBarDidTapAddFrameButton(self)
    }
    
    @objc
    private func didTapFramesButton(_ sender: ToolButton) {
        delegate?.actionsToolBarDidTapFramesButton(self)
    }
    
    @objc
    private func didTapPlayButton(_ sender: ToolButton) {
        delegate?.actionsToolBarDidTapPlayButton(self)
    }
    
    @objc
    private func didTapPauseButton(_ sender: ToolButton) {
        delegate?.actionsToolBarDidTapPauseButton(self)
    }
}
