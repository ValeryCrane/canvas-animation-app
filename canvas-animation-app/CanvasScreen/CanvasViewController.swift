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
    
    private lazy var actionsToolBar: ActionsToolBar = {
        let actionsToolBar = ActionsToolBar(delegate: self)
        actionsToolBar.setIsUndoButtonEnabled(false)
        actionsToolBar.setIsRedoButtonEnabled(false)
        actionsToolBar.setIsPlayButtonEnabled(false)
        actionsToolBar.setIsPauseButtonEnabled(false)
        
        return actionsToolBar
    }()
    
    private lazy var drawingToolBar = DrawingToolBar(
        initialStrokeColor: .res.paletteBlue5,
        initialStrokeWidth: 5,
        delegate: self
    )
    
    private let canvasView = CanvasView()
    private let canvasBackgroundView = CanvasBackgroundView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        canvasView.delegate = self
        
        layoutActionsToolBar()
        layoutDrawingToolBar()
        layoutCanvasView()
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
}

extension CanvasViewController: ActionsToolBarDelegate {
    func actionsToolBarDidTapUndoButton(_ actionsToolBar: ActionsToolBar) {
        canvasView.undo()
    }
    
    func actionsToolBarDidTapRedoButton(_ actionsToolBar: ActionsToolBar) {
        canvasView.redo()
    }
    
    func actionsToolBarDidTapDeleteButton(_ actionsToolBar: ActionsToolBar) {
        // TODO
    }
    
    func actionsToolBarDidTapAddButton(_ actionsToolBar: ActionsToolBar) {
        // TODO
    }
    
    func actionsToolBarDidTapFramesButton(_ actionsToolBar: ActionsToolBar) {
        // TODO
    }
    
    func actionsToolBarDidTapPlayButton(_ actionsToolBar: ActionsToolBar) {
        // TODO
    }
    
    func actionsToolBarDidTapPauseButton(_ actionsToolBar: ActionsToolBar) {
        // TODO
    }
}

extension CanvasViewController: DrawingToolBarDelegate {
    func drawingToolBar(_ drawingToolBar: DrawingToolBar, didSelectTool tool: (any DrawingTool)?) {
        canvasView.currentTool = tool
    }
    
    func drawingToolBar(_ drawingToolBar: DrawingToolBar, didSelectColor color: UIColor) {
        // TODO
    }
    
    func drawingToolBar(_ drawingToolBar: DrawingToolBar, didSetStrokeWidth strokeWidth: CGFloat) {
        // TODO
    }
}

extension CanvasViewController: CanvasViewDelegate {
    func canvasView(_ canvasView: CanvasView, updateIsUndoEnabled isUndoEnabled: Bool) {
        actionsToolBar.setIsUndoButtonEnabled(isUndoEnabled)
    }
    
    func canvasView(_ canvasView: CanvasView, updateIsRedoEnabled isRedoEnabled: Bool) {
        actionsToolBar.setIsRedoButtonEnabled(isRedoEnabled)
    }
}
