import Foundation
import UIKit

extension UIImage {
    func scaleToFill(_ size: CGSize) -> UIImage {
        let newSize: CGSize
        
        if self.size.height * size.width / self.size.width < size.height {
            let k = size.height / self.size.height
            newSize = .init(width: k * self.size.width, height: k * self.size.height)
        } else {
            let k = size.width / self.size.width
            newSize = .init(width: k * self.size.width, height: k * self.size.height)
        }
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? UIImage()
    }
}
