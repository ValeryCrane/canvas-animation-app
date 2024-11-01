import Foundation
import UIKit

final class ColorPickerCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ColorPickerCollectionViewCell"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
        layer.masksToBounds = true
    }
    
    func setup(color: UIColor) {
        contentView.backgroundColor = color
    }
}
