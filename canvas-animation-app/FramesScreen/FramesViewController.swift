import Foundation
import UIKit

final class FramesViewController: UIViewController {
    private let frames: [Frame]
    private let selectedIndex: Int
    private let onFrameSelected: ((Int) -> Void)?
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = UIView.layoutFittingExpandedSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = true
        collectionView.register(
            FrameCollectionViewCell.self, 
            forCellWithReuseIdentifier: FrameCollectionViewCell.reuseIdentifier
        )
        
        return collectionView
    }()
    
    init(frames: [Frame], selectedIndex: Int, onFrameSelected: ((Int) -> Void)? = nil) {
        self.frames = frames
        self.selectedIndex = selectedIndex
        self.onFrameSelected = onFrameSelected
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        collectionView.backgroundColor = .clear
        layout()
    }
    
    private func layout() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension FramesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onFrameSelected?(indexPath.row)
        dismiss(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        dismiss(animated: true)
    }
}

extension FramesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView, 
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        FrameCollectionViewCell.sizeThatFits(
            .init(width: .greatestFiniteMagnitude, height: collectionView.bounds.height),
            frame: frames[indexPath.row],
            index: indexPath.row
        )
    }
}

extension FramesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        frames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FrameCollectionViewCell.reuseIdentifier, for: indexPath
        ) as? FrameCollectionViewCell
        
        cell?.setup(frame: frames[indexPath.row], index: indexPath.row)
        return cell ?? UICollectionViewCell()
    }
}
