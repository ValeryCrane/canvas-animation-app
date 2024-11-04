import Foundation
import UIKit

final class SpinningCubeFrameGenerator: FrameGenerator {
    static let squareSidesCount: Int = 4
    
    private let cubeSize: CGFloat
    private let spinSpeed: CGFloat
    private let travelSpeed: CGFloat
    private let primaryStrokeColor: UIColor
    private let secondaryStrokeColor: UIColor
    private let strokeWidth: CGFloat
    
    init(
        cubeSize: CGFloat = 100,
        spinSpeed: CGFloat = 0.02,
        travelSpeed: CGFloat = 3,
        primaryStrokeColor: UIColor = .init(white: 0, alpha: 1),
        secondaryStrokeColor: UIColor = .init(white: 0.7, alpha: 1),
        strokeWidth: CGFloat = 3
    ) {
        self.cubeSize = cubeSize
        self.spinSpeed = spinSpeed
        self.travelSpeed = travelSpeed
        self.primaryStrokeColor = primaryStrokeColor
        self.secondaryStrokeColor = secondaryStrokeColor
        self.strokeWidth = strokeWidth
    }
    
    func generate(
        frameCount: Int, 
        frameSize: CGSize,
        completion: @escaping ([AnimationFrame]) -> Void
    ) {
        let cubeCenters = generateCubeCenters(frameCount: frameCount, frameSize: frameSize)
        var frames: [AnimationFrame] = []
        
        for i in 0 ..< frameCount {
            let spinAngle = spinSpeed * CGFloat(i)
            
            frames.append(generateFrame(
                frameSize: frameSize,
                cubeCenter: cubeCenters[i],
                spinAngle: spinAngle
            ))
        }
        
        completion(frames)
    }
    
    private func generateCubeCenters(frameCount: Int, frameSize: CGSize) -> [CGPoint] {
        let sqrt2 = CGFloat(2).squareRoot()
        let horizontalInsets = cubeSize / sqrt2
        let verticalInsets = (CGFloat(1) + sqrt2) / CGFloat(2) * cubeSize
        let insets: UIEdgeInsets = .init(
            top: verticalInsets,
            left: horizontalInsets,
            bottom: verticalInsets,
            right: horizontalInsets
        )
        
        var points = [generateRandomPoint(frameSize: frameSize, insets: insets)]
        
        while points.count < frameCount {
            let prevPoint = points[points.count - 1]
            let nextPoint = generateRandomPoint(frameSize: frameSize, insets: insets)
            let totalDistance = prevPoint.distanceTo(nextPoint)
            let frameDelta: CGPoint = .init(
                x: (nextPoint.x - prevPoint.x) * (travelSpeed / totalDistance),
                y: (nextPoint.y - prevPoint.y) * (travelSpeed / totalDistance)
            )
            
            var travelPoint = prevPoint.movedBy(delta: frameDelta)
            while travelPoint.isBetween(prevPoint, nextPoint) {
                points.append(travelPoint)
                travelPoint = travelPoint.movedBy(delta: frameDelta)
            }
        }
        
        return points.dropLast(points.count - frameCount)
    }
    
    private func generateRandomPoint(frameSize: CGSize, insets: UIEdgeInsets) -> CGPoint {
        let targetSize: CGSize = .init(
            width: frameSize.width - insets.left - insets.right,
            height: frameSize.height - insets.top - insets.bottom
        )
        
        let targetPerimeter = 2 * (targetSize.width + targetSize.height)
        var centerPerimeterCoordinate = CGFloat.random(in: 0 ..< targetPerimeter)
        
        if centerPerimeterCoordinate < targetSize.width {
            return .init(x: centerPerimeterCoordinate + insets.left, y: insets.top)
        } else {
            centerPerimeterCoordinate -= targetSize.width
        }
        
        if centerPerimeterCoordinate < targetSize.height {
            return .init(x: frameSize.width - insets.right, y: insets.top + centerPerimeterCoordinate)
        } else {
            centerPerimeterCoordinate -= targetSize.height
        }
        
        if centerPerimeterCoordinate < targetSize.width {
            return .init(
                x: frameSize.width - insets.right - centerPerimeterCoordinate,
                y: frameSize.height - insets.bottom
            )
        } else {
            centerPerimeterCoordinate -= targetSize.width
            return .init(
                x: insets.left,
                y: frameSize.height - insets.bottom - centerPerimeterCoordinate
            )
        }
    }
    
    private func generateFrame(
        frameSize: CGSize,
        cubeCenter: CGPoint,
        spinAngle: CGFloat
    ) -> AnimationFrame {
        let topSurfaceCenter = cubeCenter.movedBy(x: 0, y: -cubeSize / 2)
        let bottomSurfaceCenter = cubeCenter.movedBy(x: 0, y: cubeSize / 2)
        
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
    
    func movedBy(delta: CGPoint) -> CGPoint {
        return .init(x: self.x + delta.x, y: self.y + delta.y)
    }
    
    func distanceTo(_ point: CGPoint) -> CGFloat {
        return ((point.x - self.x) * (point.x - self.x) + (point.y - self.y) * (point.y - self.y)).squareRoot()
    }
    
    func isBetween(_ lhsPoint: CGPoint, _ rhsPoint: CGPoint) -> Bool {
        let rect = CGRect(
            x: min(lhsPoint.x, rhsPoint.x),
            y: min(lhsPoint.y, rhsPoint.y),
            width: abs(lhsPoint.x - rhsPoint.x),
            height: abs(lhsPoint.y - rhsPoint.y)
        )
        
        return rect.contains(self)
    }
}

fileprivate extension CGFloat {
    static let sqrt2: Self = CGFloat(2).squareRoot()
}
