import Foundation
import UIKit

final class FixedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    private let numberOfColumns: Int
    
    init(numberOfColumns: Int) {
        self.numberOfColumns = numberOfColumns
        
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView else { return super.collectionViewContentSize }
        
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        let numberOfRows = (numberOfItems + numberOfColumns - 1) / numberOfColumns
        
        let itemsWidth = CGFloat(numberOfColumns) * itemSize.width + CGFloat(numberOfColumns - 1) * minimumInteritemSpacing
        let totalWidth = sectionInset.left + itemsWidth + sectionInset.right
        
        let itemsHeight = CGFloat(numberOfRows) * itemSize.height + CGFloat(numberOfRows - 1) * minimumLineSpacing
        let totalHeight = sectionInset.top + itemsHeight + sectionInset.bottom
        
        return .init(width: totalWidth, height: totalHeight)
    }
}
