import Foundation
import UIKit

protocol CanvasViewDelegate: AnyObject {
    func canvasView(_ canvasView: CanvasView, updateIsUndoEnabled isUndoEnabled: Bool)
    func canvasView(_ canvasView: CanvasView, updateIsRedoEnabled isRedoEnabled: Bool)
}

final class CanvasView: UIView {
    weak var delegate: CanvasViewDelegate?
    
    private(set) var isUndoEnabled: Bool {
        didSet {
            if oldValue != isUndoEnabled {
                delegate?.canvasView(self, updateIsUndoEnabled: isUndoEnabled)
            }
        }
    }
    
    private(set) var isRedoEnabled: Bool {
        didSet {
            if oldValue != isRedoEnabled {
                delegate?.canvasView(self, updateIsRedoEnabled: isRedoEnabled)
            }
        }
    }
    
    var currentTool: (any DrawingTool)? {
        didSet {
            currentTool?.delegate = self
        }
    }
    
    private var strokesMaxIndex = 0
    private var strokes: [DrawingToolStroke] = []
    
    private let testView = UIView()
    
    init() {
        isUndoEnabled = false
        isRedoEnabled = false
        
        super.init(frame: .zero)
        
        backgroundColor = .clear
        setupGestures()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        for i in 0 ..< strokesMaxIndex {
            strokes[i].draw(inContext: context)
        }
        
        currentTool?.drawCurrentStroke(inContext: context)
    }
    
    func undo() {
        guard strokesMaxIndex > 0 else { return }
        
        strokesMaxIndex -= 1
        updateUndoAndRedoStates()
        setNeedsDisplay()
    }
    
    func redo() {
        guard strokesMaxIndex < strokes.count else { return }
        
        strokesMaxIndex += 1
        updateUndoAndRedoStates()
        setNeedsDisplay()
    }
    
    private func setupGestures() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPanGestureRecognized(_:)))
        addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc
    private func onPanGestureRecognized(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self)
        
        switch sender.state {
        case .began:
            currentTool?.startedPan(atPoint: point)
        case .changed:
            currentTool?.continuedPan(atPoint: point)
        case .ended:
            currentTool?.finishedPan(atPoint: point)
        default:
            break
        }
    }
    
    private func updateUndoAndRedoStates() {
        isUndoEnabled = strokesMaxIndex > 0
        isRedoEnabled = strokesMaxIndex < strokes.count
    }
}

extension CanvasView: DrawingToolDelegate {
    func drawingToolSetNeedsDisplay(_ drawingTool: any DrawingTool) {
        setNeedsDisplay()
    }
    
    func drawingTool(_ drawingTool: any DrawingTool, didCreateStroke stroke: any DrawingToolStroke) {
        strokes = strokes.dropLast(strokes.count - strokesMaxIndex)
        strokes.append(stroke)
        strokesMaxIndex = strokes.count
        
        updateUndoAndRedoStates()
    }
}