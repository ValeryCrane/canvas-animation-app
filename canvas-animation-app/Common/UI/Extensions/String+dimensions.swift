import Foundation
import UIKit

extension String {
    func estimatedSize(withFont font: UIFont) -> CGSize {
        let estimatedSize = self.boundingRect(
            with: .init(
                width: CGFloat.greatestFiniteMagnitude,
                height: CGFloat.greatestFiniteMagnitude
            ),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )
        
        return .init(
            width: ceil(estimatedSize.width),
            height: ceil(estimatedSize.height)
        )
    }
    
    func estimatedHeight(withFont font: UIFont, width: CGFloat) -> CGFloat {
        let estimatedSize = self.boundingRect(
            with: .init(
                width: width,
                height: CGFloat.greatestFiniteMagnitude
            ),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )
        
        return ceil(estimatedSize.height)
    }
    
    func estimatedWidth(withFont font: UIFont, height: CGFloat) -> CGFloat {
        let estimatedSize = self.boundingRect(
            with: .init(
                width: CGFloat.greatestFiniteMagnitude,
                height: height
            ),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )
        
        return ceil(estimatedSize.width)
    }
}
