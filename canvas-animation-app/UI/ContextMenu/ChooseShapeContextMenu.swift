import Foundation
import UIKit

protocol ChooseShapeContextMenuDelegate: AnyObject {
    func chooseShapeContextMenu(
        _ chooseShapeContextMenu: ChooseShapeContextMenu, didSelectShape shape: Tool.Shape
    )
}

extension ChooseShapeContextMenu {
    private enum Constants {
        static let verticalMargin: CGFloat = 16
        static let horizontalMargin: CGFloat = 16
        static let shapeButtonWidth: CGFloat = 24
        static let shapeButtonHeight: CGFloat = 24
        static let shapesSpacing: CGFloat = 16
        static let cornerRadius: CGFloat = 4
        
        static let alphaAnimationDuration: Double = 0.2
    }
}

final class ChooseShapeContextMenu: UIVisualEffectView {
    weak var delegate: ChooseShapeContextMenuDelegate?
    
    var shape: Tool.Shape?
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = FixedCollectionViewFlowLayout(numberOfColumns: Tool.Shape.allCases.count)
        flowLayout.itemSize = .init(width: Constants.shapeButtonWidth, height: Constants.shapeButtonHeight)
        flowLayout.minimumInteritemSpacing = Constants.shapesSpacing
        flowLayout.minimumLineSpacing = Constants.shapesSpacing
        flowLayout.sectionInset = .init(
            top: Constants.verticalMargin,
            left: Constants.horizontalMargin,
            bottom: Constants.verticalMargin,
            right: Constants.horizontalMargin
        )
        
        let collectionView = AutoSizingCollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(
            ToolCollectionViewCell.self,
            forCellWithReuseIdentifier: ToolCollectionViewCell.reuseIdentifier
        )
        
        return collectionView
    }()
    
    init(delegate: ChooseShapeContextMenuDelegate? = nil, shape: Tool.Shape? = nil) {
        self.delegate = delegate
        self.shape = shape
        
        super.init(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        
        layout()
        alpha = 0
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true
    }
}

extension ChooseShapeContextMenu: ContextMenu {
    func setupConstraints(anchorViewLayoutGuide: UILayoutGuide, screenLayoutGuide: UILayoutGuide) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: screenLayoutGuide.centerXAnchor),
            bottomAnchor.constraint(equalTo: anchorViewLayoutGuide.topAnchor, constant: -16)
        ])
    }
    
    func onAppear(completion: (() -> Void)?) {
        UIView.animate(withDuration: Constants.alphaAnimationDuration) {
            self.alpha = 1
        } completion: { _ in
            completion?()
        }
    }
    
    func onDismiss(completion: (() -> Void)?) {
        UIView.animate(withDuration: Constants.alphaAnimationDuration) {
            self.alpha = 0
        } completion: { _ in
            completion?()
        }
    }
}

extension ChooseShapeContextMenu: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.chooseShapeContextMenu(self, didSelectShape: Tool.Shape.allCases[indexPath.row])
    }
}

extension ChooseShapeContextMenu: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Tool.Shape.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ToolCollectionViewCell.reuseIdentifier, for: indexPath
        ) as? ToolCollectionViewCell
        
        cell?.setup(image: Tool.Shape.allCases[indexPath.row].image())
        return cell ?? UICollectionViewCell()
    }
}
