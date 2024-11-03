import Foundation
import UIKit

protocol DrawingToolStroke {
    func draw(inContext context: CGContext)
    func withAlphaComponent(_ alpha: CGFloat) -> Self
}

protocol DrawingTool {
    associatedtype Stroke: DrawingToolStroke
    
    static func drawStroke(_ stroke: Stroke, inContext context: CGContext)
    
    var delegate: DrawingToolDelegate? { get set }
    
    func startedPan(atPoint point: CGPoint)
    func continuedPan(atPoint point: CGPoint)
    func finishedPan(atPoint point: CGPoint)
    
    func drawCurrentStroke(inContext context: CGContext)
}

protocol DrawingToolDelegate: AnyObject {
    func drawingToolSetNeedsDisplay(_ drawingTool: any DrawingTool)
    func drawingTool(
        _ drawingTool: any DrawingTool, 
        didCreateStroke stroke: any DrawingToolStroke
    )
}
