import Foundation
import UIKit

struct EraserStroke: DrawingToolStroke {
    func draw(inContext context: CGContext) {
        EraserDrawingTool.drawStroke(self, inContext: context)
    }
    
    let strokeWidth: CGFloat
    let points: [CGPoint]
}

final class EraserDrawingTool: DrawingTool {
    typealias Stroke = EraserStroke
    
    static func drawStroke(_ stroke: EraserStroke, inContext context: CGContext) {
        context.setBlendMode(.copy)
        context.setStrokeColor(UIColor.clear.cgColor)
        context.setLineWidth(stroke.strokeWidth)
        
        for (index, point) in stroke.points.enumerated() {
            switch index {
            case 0:
                context.move(to: point)
            default:
                context.addLine(to: point)
            }
        }
        
        context.strokePath()
    }
    
    var delegate: DrawingToolDelegate?
    
    let strokeWidth: CGFloat
    
    var currentStrokePoints: [CGPoint] = []
    
    init(strokeWidth: CGFloat) {
        self.strokeWidth = strokeWidth
    }
    
    func startedPan(atPoint point: CGPoint) {
        currentStrokePoints = [point]
    }
    
    func continuedPan(atPoint point: CGPoint) {
        currentStrokePoints.append(point)
        delegate?.drawingToolSetNeedsDisplay(self)
    }
    
    func finishedPan(atPoint point: CGPoint) {
        currentStrokePoints.append(point)
        guard currentStrokePoints.count > 1 else { return }
        
        let strokeInfo = Stroke(
            strokeWidth: strokeWidth,
            points: currentStrokePoints
        )
        
        currentStrokePoints = []
        delegate?.drawingTool(self, didCreateStroke: strokeInfo)
        delegate?.drawingToolSetNeedsDisplay(self)
    }
    
    func drawCurrentStroke(inContext context: CGContext) {
        guard currentStrokePoints.count > 1 else { return }
        
        context.setBlendMode(.copy)
        context.setStrokeColor(UIColor.clear.cgColor)
        context.setLineWidth(strokeWidth)
        
        for (index, point) in currentStrokePoints.enumerated() {
            switch index {
            case 0:
                context.move(to: point)
            default:
                context.addLine(to: point)
            }
        }
        
        context.strokePath()
    }
}
