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
        initialColorPickerColor: .res.paletteBlue5,
        delegate: self
    )
    
    private let canvasView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
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
        view.addSubview(canvasView)
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        canvasView.layer.cornerRadius = Constants.canvasViewCornerRadius
        canvasView.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            canvasView.topAnchor.constraint(
                equalTo: actionsToolBar.bottomAnchor, constant: Constants.canvasViewTopMargin
            ),
            canvasView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: Constants.canvasViewSideMargin
            ),
            canvasView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -Constants.canvasViewSideMargin
            ),
            canvasView.bottomAnchor.constraint(
                equalTo: drawingToolBar.topAnchor, constant: -Constants.canvasViewBottomMargin
            )
        ])
    }
}

extension CanvasViewController: ActionsToolBarDelegate {
    func actionsToolBarDidTapUndoButton(_ actionsToolBar: ActionsToolBar) {
        // TODO
    }
    
    func actionsToolBarDidTapRedoButton(_ actionsToolBar: ActionsToolBar) {
        // TODO
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
    func drawingToolBar(_ drawingToolBar: DrawingToolBar, didSelectTool tool: Tool?) {
        // TODO
    }
    
    func drawingToolBar(_ drawingToolBar: DrawingToolBar, didSelectColor color: UIColor) {
        // TODO
    }
    
    func drawingToolBar(_ drawingToolBar: DrawingToolBar, didSetStrokeWidth strokeWidth: CGFloat) {
        // TODO
    }
}
