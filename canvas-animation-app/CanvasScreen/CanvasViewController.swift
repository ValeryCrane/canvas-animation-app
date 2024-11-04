import Foundation
import UIKit

extension CanvasViewController {
    private enum Constants {
        static let actionsToolBarTopMargin: CGFloat = 15
        static let actionsToolBarSideMargin: CGFloat = 16
        
        static let canvasViewTopMargin: CGFloat = 32
        static let canvasViewSideMargin: CGFloat = 16
        static let canvasViewBottomMargin: CGFloat = 22
        
        static let drawingToolBarBottomMargin: CGFloat = 0
        static let drawingToolBarSideMargin: CGFloat = 16
        
        static let canvasViewCornerRadius: CGFloat = 20
    }
}

final class CanvasViewController: UIViewController {
    private var model: CanvasModelInput
    
    private lazy var actionsToolBar: ActionsToolBar = {
        let actionsToolBar = ActionsToolBar(delegate: self)
        actionsToolBar.setIsUndoButtonEnabled(false)
        actionsToolBar.setIsRedoButtonEnabled(false)
        actionsToolBar.setIsPauseButtonEnabled(false)
        actionsToolBar.setIsDeleteFrameButtonEnabled(false)
        
        return actionsToolBar
    }()
    
    private lazy var drawingToolBar = DrawingToolBar(
        initialStrokeColor: .res.paletteBlue5,
        initialStrokeWidth: 5,
        delegate: self
    )
    
    private let canvasView = CanvasView()
    private let canvasBackgroundView = CanvasBackgroundView()
    
    private let animationView = CanvasAnimationView()
    private let animationBackgroundView = CanvasBackgroundView()
    
    private var areCanvasToolsEnabled: Bool = true
    
    init(model: CanvasModelInput) {
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        canvasView.delegate = self
        animationBackgroundView.isHidden = true
        
        layoutActionsToolBar()
        layoutDrawingToolBar()
        layoutCanvasView()
        layoutCanvasAnimationView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        model.viewDidAppear()
    }
    
    private func layoutActionsToolBar() {
        view.addSubview(actionsToolBar)
        actionsToolBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            actionsToolBar.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.actionsToolBarTopMargin
            ),
            actionsToolBar.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: Constants.actionsToolBarSideMargin
            ),
            actionsToolBar.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -Constants.actionsToolBarSideMargin
            )
        ])
    }
    
    private func layoutDrawingToolBar() {
        view.addSubview(drawingToolBar)
        drawingToolBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            drawingToolBar.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.drawingToolBarBottomMargin
            ),
            drawingToolBar.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: Constants.drawingToolBarSideMargin
            ),
            drawingToolBar.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -Constants.drawingToolBarSideMargin
            )
        ])
    }
    
    private func layoutCanvasView() {
        view.addSubview(canvasBackgroundView)
        canvasBackgroundView.addSubview(canvasView)
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        canvasBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        canvasBackgroundView.layer.cornerRadius = Constants.canvasViewCornerRadius
        canvasBackgroundView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            canvasBackgroundView.topAnchor.constraint(
                equalTo: actionsToolBar.bottomAnchor, constant: Constants.canvasViewTopMargin
            ),
            canvasBackgroundView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: Constants.canvasViewSideMargin
            ),
            canvasBackgroundView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -Constants.canvasViewSideMargin
            ),
            canvasBackgroundView.bottomAnchor.constraint(
                equalTo: drawingToolBar.topAnchor, constant: -Constants.canvasViewBottomMargin
            ),
            
            canvasView.topAnchor.constraint(equalTo: canvasBackgroundView.topAnchor),
            canvasView.leadingAnchor.constraint(equalTo: canvasBackgroundView.leadingAnchor),
            canvasView.trailingAnchor.constraint(equalTo: canvasBackgroundView.trailingAnchor),
            canvasView.bottomAnchor.constraint(equalTo: canvasBackgroundView.bottomAnchor)
        ])
    }
    
    private func layoutCanvasAnimationView() {
        view.addSubview(animationBackgroundView)
        animationBackgroundView.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        animationBackgroundView.layer.cornerRadius = Constants.canvasViewCornerRadius
        animationBackgroundView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            animationBackgroundView.topAnchor.constraint(equalTo: canvasBackgroundView.topAnchor),
            animationBackgroundView.leadingAnchor.constraint(equalTo: canvasBackgroundView.leadingAnchor),
            animationBackgroundView.trailingAnchor.constraint(equalTo: canvasBackgroundView.trailingAnchor),
            animationBackgroundView.bottomAnchor.constraint(equalTo: canvasBackgroundView.bottomAnchor),
            
            animationView.topAnchor.constraint(equalTo: animationBackgroundView.topAnchor),
            animationView.leadingAnchor.constraint(equalTo: animationBackgroundView.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: animationBackgroundView.trailingAnchor),
            animationView.bottomAnchor.constraint(equalTo: animationBackgroundView.bottomAnchor)
        ])
    }
}

extension CanvasViewController: CanvasModelOutput {
    func getCurrentFrame() -> AnimationFrame {
        canvasView.getFrame()
    }
    
    func changeFrame(frame: AnimationFrame, undelyingFrame: AnimationFrame?) {
        canvasView.setFrame(frame, underlyingFrame: undelyingFrame)
    }
    
    func startAnimation(frames: [AnimationFrame], fps: Int) {
        animationBackgroundView.isHidden = false
        animationView.startAnimation(frames: frames, fps: fps)
    }
    
    func endAnimation() {
        animationBackgroundView.isHidden = true
        animationView.endAnimation()
    }
    
    func setIsDeleteButtonEnabled(_ isEnabled: Bool) {
        actionsToolBar.setIsDeleteFrameButtonEnabled(isEnabled)
    }
    
    func setIsAddFrameButtonEnabled(_ isEnabled: Bool) {
        actionsToolBar.setIsAddFrameButtonEnabled(isEnabled)
    }
    
    func setIsFramesButtonEnabled(_ isEnabled: Bool) {
        actionsToolBar.setIsFramesButtonEnabled(isEnabled)
    }
    
    func setIsPlayButtonEnabled(_ isEnabled: Bool) {
        actionsToolBar.setIsPlayButtonEnabled(isEnabled)
    }
    
    func setIsPauseButtonEnabled(_ isEnabled: Bool) {
        actionsToolBar.setIsPauseButtonEnabled(isEnabled)
    }
    
    func setAreCanvasToolsEnabled(_ areEnabled: Bool) {
        areCanvasToolsEnabled = areEnabled
        
        actionsToolBar.setIsUndoButtonEnabled(canvasView.isUndoEnabled && areCanvasToolsEnabled)
        actionsToolBar.setIsRedoButtonEnabled(canvasView.isRedoEnabled && areCanvasToolsEnabled)
        drawingToolBar.setIsEnabled(areCanvasToolsEnabled)
    }
}

extension CanvasViewController: CanvasViewDelegate {
    func canvasView(_ canvasView: CanvasView, didAlterFrame frame: AnimationFrame) {
        model.didAlterCurrentFrame(frame: frame)
    }
    
    func canvasView(_ canvasView: CanvasView, updateIsUndoEnabled isUndoEnabled: Bool) {
        actionsToolBar.setIsUndoButtonEnabled(isUndoEnabled && areCanvasToolsEnabled)
    }
    
    func canvasView(_ canvasView: CanvasView, updateIsRedoEnabled isRedoEnabled: Bool) {
        actionsToolBar.setIsRedoButtonEnabled(isRedoEnabled && areCanvasToolsEnabled)
    }
}

extension CanvasViewController: ActionsToolBarDelegate {
    func actionsToolBarDidTapUndoButton(_ actionsToolBar: ActionsToolBar) {
        canvasView.undo()
    }
    
    func actionsToolBarDidTapRedoButton(_ actionsToolBar: ActionsToolBar) {
        canvasView.redo()
    }
    
    func actionsToolBarDidTapDeleteFrameButton(_ actionsToolBar: ActionsToolBar) {
        model.didTapDeleteFrameButton()
    }
    
    func actionsToolBarDidTapDeleteAllFramesButton(_ actionsToolBar: ActionsToolBar) {
        model.didTapDeleteAllFramesButton()
    }
    
    func actionsToolBarDidTapAddFrameButton(_ actionsToolBar: ActionsToolBar) {
        model.didTapAddFrameButton()
    }
    
    func actionsToolBarDidTapDuplicateFrameButton(_ actionsToolBar: ActionsToolBar) {
        model.didTapDuplicateFrameButton()
    }
    
    func actionsToolBarDidTapGenerateFramesButton(_ actionsToolBar: ActionsToolBar) {
        let generateFramesAlertController = UIAlertController(
            title: "Генерация кадров",
            message: "Введите количество кадров для генерации",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        let generateAction = UIAlertAction(
            title: "Сгенерировать", style: .default
        ) { [weak self, weak generateFramesAlertController] _ in
            let textField = generateFramesAlertController?.textFields?.first
            if let text = textField?.text, let count = Int(text) {
                self?.model.didRequestToGenerateFrames(count: count)
            }
        }
        
        generateAction.isEnabled = false
        
        generateFramesAlertController.addTextField { textField in
            textField.keyboardType = .numberPad
            textField.addAction(.init(handler: { [weak textField] _ in
                if let text = textField?.text, let count = Int(text), count > 0 {
                    generateAction.isEnabled = true
                } else {
                    generateAction.isEnabled = false
                }
            }), for: .editingChanged)
        }
        
        generateFramesAlertController.addAction(cancelAction)
        generateFramesAlertController.addAction(generateAction)
        present(generateFramesAlertController, animated: true)
    }
    
    func actionsToolBarDidTapFramesButton(_ actionsToolBar: ActionsToolBar) {
        model.didTapFramesButton()
    }
    
    func actionsToolBarDidTapPlayButton(_ actionsToolBar: ActionsToolBar) {
        model.didTapPlayButton()
    }
    
    func actionsToolBarDidTapPauseButton(_ actionsToolBar: ActionsToolBar) {
        model.didTapPauseButton()
    }
    
    func actionsToolBarDidTapChangeFPSButton(_ actionsToolBar: ActionsToolBar) {
        showChangeFPSContextMenu()
    }
    
    private func showChangeFPSContextMenu() {
        drawingToolBar.showContextMenu(FPSContextMenu(initialFPS: model.getAnimationFPS(), delegate: self))
    }
}

extension CanvasViewController: DrawingToolBarDelegate {
    func drawingToolBar(_ drawingToolBar: DrawingToolBar, didSelectTool tool: (any DrawingTool)?) {
        canvasView.currentTool = tool
    }
}

extension CanvasViewController: FPSContextMenuDelegate {
    func fpsContextMenu(_ fpsContextMenu: FPSContextMenu, didChangeFPS fps: Int) {
        drawingToolBar.dismissContextMenusAndResetState()
        model.didRequestToChangeAnimationFPS(fps)
    }
}
