import Foundation
import UIKit

final class SpinningCubeFrameGenerator: FrameGenerator {
    static let squareSidesCount: Int = 4
    
    private let cubeSize: CGFloat
    private let spinSpeed: CGFloat
    private let primaryStrokeColor: UIColor
    private let secondaryStrokeColor: UIColor
    private let strokeWidth: CGFloat
    
    init(
        cubeSize: CGFloat = 100,
        spinSpeed: CGFloat = 0.02,
        primaryStrokeColor: UIColor = .init(white: 0, alpha: 1),
        secondaryStrokeColor: UIColor = .init(white: 0.7, alpha: 1),
        strokeWidth: CGFloat = 3
    ) {
        self.cubeSize = cubeSize
        self.spinSpeed = spinSpeed
        self.primaryStrokeColor = primaryStrokeColor
        self.secondaryStrokeColor = secondaryStrokeColor
        self.strokeWidth = strokeWidth
    }
    
    func generate(
        frameCount: Int, 
        frameSize: CGSize,
        completion: @escaping ([AnimationFrame]) -> Void
    ) {
        let frameCenter = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
        let topSurfaceCenter = frameCenter.movedBy(x: 0, y: -cubeSize / 2)
        let bottomSurfaceCenter = frameCenter.movedBy(x: 0, y: cubeSize / 2)
        
        var frames: [AnimationFrame] = []
        
        for i in 0 ..< frameCount {
            let spinAngle = spinSpeed * CGFloat(i)
            
            frames.append(generateFrame(
                frameSize: frameSize,
                topSurfaceCenter: topSurfaceCenter,
                bottomSurfaceCenter: bottomSurfaceCenter,
                spinAngle: spinAngle
            ))
        }
        
        completion(frames)
    }
    
    private func generateFrame(
        frameSize: CGSize,
        topSurfaceCenter: CGPoint,
        bottomSurfaceCenter: CGPoint,
        spinAngle: CGFloat
    ) -> AnimationFrame {
        let topSurfacePoints: [CGPoint] = generateSurfacePoints(
            surfaceCenter: topSurfaceCenter, spinAngle: spinAngle
        )
        
        let bottomSurfacePoints: [CGPoint] = generateSurfacePoints(
            surfaceCenter: bottomSurfaceCenter, spinAngle: spinAngle
        )
        
        let strokes = generateStrokes(
            topSurfacePoints: topSurfacePoints,
            bottomSurfacePoints: bottomSurfacePoints
        )
        
        return .init(
            size: frameSize,
            strokesMaxIndex: strokes.count,
            strokes: strokes
        )
    }
    
    private func generateSurfacePoints(
        surfaceCenter: CGPoint, spinAngle: CGFloat
    ) -> [CGPoint] {
        let sqrt2 = CGFloat(2).squareRoot()
        let sideAngle = 2 * CGFloat.pi / CGFloat(Self.squareSidesCount)
        let halfDiagonal = cubeSize / sqrt2
        
        var surfacePoints: [CGPoint] = []
        
        for i in 0 ..< Self.squareSidesCount {
            let angle = spinAngle + CGFloat(i) * sideAngle
            
            surfacePoints.append(surfaceCenter.movedBy(
                x: halfDiagonal * cos(angle),
                y: -halfDiagonal * sin(angle)
            ))
        }
        
        return surfacePoints
    }
    
    private func generateStrokes(
        topSurfacePoints: [CGPoint], bottomSurfacePoints: [CGPoint]
    ) -> [DrawingToolStroke] {
        let farthestPointIndex = bottomSurfacePoints.enumerated().min(
            by: { $0.element.y < $1.element.y }
        )?.offset ?? 0
        
        var strokes: [DrawingToolStroke] = []
        
        for i in 0 ..< Self.squareSidesCount {
            let isSecondaryStroke = (i == farthestPointIndex) || ((i + 1) % Self.squareSidesCount == farthestPointIndex)
            
            strokes.append(PencilStroke(
                strokeColor: isSecondaryStroke ? secondaryStrokeColor : primaryStrokeColor,
                strokeWidth: strokeWidth,
                points: [
                    bottomSurfacePoints[i],
                    bottomSurfacePoints[(i + 1) % Self.squareSidesCount]
                ]
            ))
        }
        
        for i in 0 ..< Self.squareSidesCount {
            strokes.append(PencilStroke(
                strokeColor: i == farthestPointIndex ? secondaryStrokeColor : primaryStrokeColor,
                strokeWidth: strokeWidth,
                points: [
                    topSurfacePoints[i],
                    bottomSurfacePoints[i]
                ]
            ))
        }
        
        for i in 0 ..< Self.squareSidesCount {
            strokes.append(PencilStroke(
                strokeColor: primaryStrokeColor,
                strokeWidth: strokeWidth,
                points: [
                    topSurfacePoints[i],
                    topSurfacePoints[(i + 1) % Self.squareSidesCount]
                ]
            ))
        }
        
        return strokes
    }
}

fileprivate extension CGPoint {
    func movedBy(x: CGFloat, y: CGFloat) -> CGPoint {
        return .init(x: self.x + x, y: self.y + y)
    }
}

fileprivate extension CGFloat {
    static let sqrt2: Self = CGFloat(2).squareRoot()
}
