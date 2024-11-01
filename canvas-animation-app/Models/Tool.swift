import Foundation
import UIKit

enum Tool {
    case pencil
    case eraser
    case shape(Shape)
    
    enum Shape: CaseIterable {
        case square
        case circle
        case triangle
        case arrow
        
        func image() -> UIImage {
            switch self {
            case .square:
                .res.square
            case .circle:
                .res.circle
            case .triangle:
                .res.triangle
            case .arrow:
                .res.arrowUp
            }
        }
    }
}
