import Foundation
import UIKit

struct RectangleStroke: DrawingToolStroke {
    func draw(inContext context: CGContext) {
        RectangleDrawingTool.drawStroke(self, inContext: context)
    }
    
    let strokeColor: UIColor
    let strokeWidth: CGFloat
    let startPoint: CGPoint
    let endPoint: CGPoint
}

final class RectangleDrawingTool: DrawingTool {
    typealias Stroke = RectangleStroke
    
    static func drawStroke(_ stroke: RectangleStroke, inContext context: CGContext) {
        context.setBlendMode(.copy)
        context.setStrokeColor(stroke.strokeColor.cgColor)
        context.setLineWidth(stroke.strokeWidth)
        
        context.stroke(.init(from: stroke.startPoint, to: stroke.endPoint))
    }
    
    var delegate: DrawingToolDelegate?
    
    let strokeColor: UIColor
    let strokeWidth: CGFloat
    
    var startPoint: CGPoint?
    var endPoint: CGPoint?
    
    init(strokeColor: UIColor, strokeWidth: CGFloat) {
        self.strokeColor = strokeColor
        self.strokeWidth = strokeWidth
    }
    
    func startedPan(atPoint point: CGPoint) {
        startPoint = point
    }
    
    func continuedPan(atPoint point: CGPoint) {
        guard let startPoint else { return }
        
        endPoint = point
        delegate?.drawingToolSetNeedsDisplay(self)
    }
    
    func finishedPan(atPoint point: CGPoint) {
        guard let startPoint else { return }
        
        let stroke = Stroke(
            strokeColor: strokeColor,
            strokeWidth: strokeWidth,
            startPoint: startPoint,
            endPoint: point
        )
        
        self.startPoint = nil
        self.endPoint = nil
        
        delegate?.drawingTool(self, didCreateStroke: stroke)
    }
    
    func drawCurrentStroke(inContext context: CGContext) {
        guard let startPoint, let endPoint else { return }

        context.setBlendMode(.copy)
        context.setStrokeColor(strokeColor.cgColor)
        context.setLineWidth(strokeWidth)
        
        context.stroke(.init(from: startPoint, to: endPoint))
    }
}

fileprivate extension CGRect {
    init(from startPoint: CGPoint, to endPoint: CGPoint) {
        self.init(
            x: min(startPoint.x, endPoint.x),
            y: min(startPoint.y, endPoint.y),
            width: abs(endPoint.x - startPoint.x),
            height: abs(endPoint.y - startPoint.y)
        )
    }
}
