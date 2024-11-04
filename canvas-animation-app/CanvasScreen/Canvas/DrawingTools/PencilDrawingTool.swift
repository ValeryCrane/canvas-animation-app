import Foundation
import UIKit

struct PencilStroke: DrawingToolStroke {
    func draw(inContext context: CGContext) {
        PencilDrawingTool.drawStroke(self, inContext: context)
    }
    
    let strokeColor: UIColor
    let strokeWidth: CGFloat
    let points: [CGPoint]
}

final class PencilDrawingTool: DrawingTool {
    typealias Stroke = PencilStroke
    
    static func drawStroke(_ stroke: PencilStroke, inContext context: CGContext) {
        context.setBlendMode(.copy)
        context.setStrokeColor(stroke.strokeColor.cgColor)
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
    
    let strokeColor: UIColor
    let strokeWidth: CGFloat
    
    var currentStrokePoints: [CGPoint] = []
    
    init(strokeColor: UIColor, strokeWidth: CGFloat) {
        self.strokeColor = strokeColor
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
            strokeColor: strokeColor,
            strokeWidth: strokeWidth,
            points: currentStrokePoints
        )
        
        currentStrokePoints = []
        delegate?.drawingTool(self, didCreateStroke: strokeInfo)
    }
    
    func drawCurrentStroke(inContext context: CGContext) {
        guard currentStrokePoints.count > 1 else { return }
        
        context.setBlendMode(.copy)
        context.setStrokeColor(strokeColor.cgColor)
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
