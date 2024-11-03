import Foundation
import UIKit

// MARK: ColorPickerContextMenuDelegate

protocol ColorPickerContextMenuDelegate: AnyObject {
    func colorPickerContextMenu(
        _ colorPickerContextMenu: ColorPickerContextMenu, didPickColor color: UIColor
    )
}

// MARK: Constants

extension ColorPickerContextMenu {
    private enum Constants {
        static let numberOfColumns: Int = 5
        
        static let verticalMargin: CGFloat = 16
        static let horizontalMargin: CGFloat = 16
        
        static let paletteButtonHeight: CGFloat = 32
        static let paletteButtonWidth: CGFloat = 32
        static let paletteVerticalSpacing: CGFloat = 16
        static let paletteHorizontalSpacing: CGFloat = 16
        
        static let sectionSpacing: CGFloat = 8
        static let cornerRadius: CGFloat = 4
        
        static let alphaAnimationDuration: Double = 0.2
    }
}

// MARK: ColorPickerContextMenu

final class ColorPickerContextMenu: UIView {
    weak var delegate: ColorPickerContextMenuDelegate?
    
    private let briefBackgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
    private let fullBackgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
    
    private lazy var briefCollectionView: UICollectionView = {
        let collectionView = AutoSizingCollectionView(
            frame: .zero,
            collectionViewLayout: createCollectionViewFlowLayout()
        )
        
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        
        collectionView.register(
            ToolCollectionViewCell.self,
            forCellWithReuseIdentifier: ToolCollectionViewCell.reuseIdentifier
        )
        
        collectionView.register(
            ColorPickerCollectionViewCell.self,
            forCellWithReuseIdentifier: ColorPickerCollectionViewCell.reuseIdentifier
        )
        
        return collectionView
    }()
    
    private lazy var fullCollectionView: UICollectionView = {
        let collectionView = AutoSizingCollectionView(
            frame: .zero,
            collectionViewLayout: createCollectionViewFlowLayout()
        )
        
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(
            ColorPickerCollectionViewCell.self,
            forCellWithReuseIdentifier: ColorPickerCollectionViewCell.reuseIdentifier
        )
        
        return collectionView
    }()
    
    init(delegate: ColorPickerContextMenuDelegate? = nil) {
        self.delegate = delegate
        
        super.init(frame: .zero)
        
        layout()
        alpha = 0
        setIsPalleteExpanded(false, animated: false)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        let stackView = UIStackView(arrangedSubviews: [fullBackgroundView, briefBackgroundView])
        stackView.axis = .vertical
        stackView.spacing = Constants.sectionSpacing
        
        addSubview(stackView)
        briefBackgroundView.contentView.addSubview(briefCollectionView)
        fullBackgroundView.contentView.addSubview(fullCollectionView)
        
        [stackView, briefCollectionView, fullCollectionView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            briefCollectionView.topAnchor.constraint(equalTo: briefBackgroundView.contentView.topAnchor),
            briefCollectionView.leadingAnchor.constraint(equalTo: briefBackgroundView.contentView.leadingAnchor),
            briefCollectionView.trailingAnchor.constraint(equalTo: briefBackgroundView.contentView.trailingAnchor),
            briefCollectionView.bottomAnchor.constraint(equalTo: briefBackgroundView.contentView.bottomAnchor),
            
            fullCollectionView.topAnchor.constraint(equalTo: fullBackgroundView.contentView.topAnchor),
            fullCollectionView.leadingAnchor.constraint(equalTo: fullBackgroundView.contentView.leadingAnchor),
            fullCollectionView.trailingAnchor.constraint(equalTo: fullBackgroundView.contentView.trailingAnchor),
            fullCollectionView.bottomAnchor.constraint(equalTo: fullBackgroundView.contentView.bottomAnchor)
        ])
        
        briefBackgroundView.layer.cornerRadius = Constants.cornerRadius
        fullBackgroundView.layer.cornerRadius = Constants.cornerRadius
        briefBackgroundView.clipsToBounds = true
        fullBackgroundView.clipsToBounds = true
    }
    
    private func createCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = FixedCollectionViewFlowLayout(numberOfColumns: Constants.numberOfColumns)
        flowLayout.itemSize = .init(width: Constants.paletteButtonWidth, height: Constants.paletteButtonHeight)
        flowLayout.minimumInteritemSpacing = Constants.paletteHorizontalSpacing
        flowLayout.minimumLineSpacing = Constants.paletteVerticalSpacing
        flowLayout.sectionInset = .init(
            top: Constants.verticalMargin,
            left: Constants.horizontalMargin,
            bottom: Constants.verticalMargin,
            right: Constants.horizontalMargin
        )
        
        return flowLayout
    }
    
    private func setIsPalleteExpanded(_ isExpanded: Bool, animated: Bool) {
        guard isExpanded == fullBackgroundView.isHidden else { return }
        
        if isExpanded {
            fullBackgroundView.isHidden = false
            UIView.animate(withDuration: animated ? Constants.alphaAnimationDuration : 0) {
                self.fullBackgroundView.alpha = 1
            }
        } else {
            UIView.animate(withDuration: animated ? Constants.alphaAnimationDuration : 0) {
                self.fullBackgroundView.alpha = 0
            } completion: { _ in
                self.fullBackgroundView.isHidden = true
            }
        }
    }
}

// MARK: ContextMenu

extension ColorPickerContextMenu: ContextMenu {
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

// MARK: UICollectionViewDelegate

extension ColorPickerContextMenu: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == briefCollectionView {
            switch indexPath.row {
            case 0:
                setIsPalleteExpanded(true, animated: true)
            default:
                delegate?.colorPickerContextMenu(
                    self, didPickColor: UIColor.res.briefPalette[indexPath.row - 1]
                )
            }
        } else {
            delegate?.colorPickerContextMenu(self, didPickColor: UIColor.res.fullPalette[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == briefCollectionView {
            switch indexPath.row {
            case 0:
                setIsPalleteExpanded(false, animated: true)
            default:
                break
            }
        }
    }
}

// MARK: UICollectionViewDataSource

extension ColorPickerContextMenu: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == briefCollectionView {
            return briefCollectionView(collectionView, numberOfItemsInSection: section)
        } else {
            return fullCollectionView(collectionView, numberOfItemsInSection: section)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == briefCollectionView {
            return briefCollectionView(collectionView, cellForItemAt: indexPath)
        } else {
            return fullCollectionView(collectionView, cellForItemAt: indexPath)
        }
    }
    
    private func briefCollectionView(
        _ collectionView: UICollectionView, numberOfItemsInSection section: Int
    ) -> Int {
        UIColor.res.briefPalette.count + 1
    }
    
    private func fullCollectionView(
        _ collectionView: UICollectionView, numberOfItemsInSection section: Int
    ) -> Int {
        UIColor.res.fullPalette.count
    }
    
    private func briefCollectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ToolCollectionViewCell.reuseIdentifier, for: indexPath
            ) as? ToolCollectionViewCell
            
            cell?.setup(image: .res.palette)
            return cell ?? UICollectionViewCell()
            
        default:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ColorPickerCollectionViewCell.reuseIdentifier, for: indexPath
            ) as? ColorPickerCollectionViewCell
            
            cell?.setup(color: UIColor.res.briefPalette[indexPath.row - 1])
            return cell ?? UICollectionViewCell()
        }
    }
    
    private func fullCollectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ColorPickerCollectionViewCell.reuseIdentifier, for: indexPath
        ) as? ColorPickerCollectionViewCell
        
        cell?.setup(color: UIColor.res.fullPalette[indexPath.row])
        return cell ?? UICollectionViewCell()
    }
}