import Foundation
import UIKit

extension LoadingViewController {
    private enum Constants {
        static let loadingViewSize: CGFloat = 64
        static let cornerRadius: CGFloat = 8
    }
}

class LoadingViewController: UIViewController {
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        activityIndicator.style = .medium
        activityIndicator.tintColor = .res.tool
        activityIndicator.startAnimating()
        
        layout()
    }
    
    private func layout() {
        let loadingView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        loadingView.layer.cornerRadius = Constants.cornerRadius
        loadingView.clipsToBounds = true
        
        view.addSubview(loadingView)
        loadingView.contentView.addSubview(activityIndicator)
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.widthAnchor.constraint(equalToConstant: Constants.loadingViewSize),
            loadingView.heightAnchor.constraint(equalToConstant: Constants.loadingViewSize),
            
            activityIndicator.centerXAnchor.constraint(equalTo: loadingView.contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loadingView.contentView.centerYAnchor)
        ])
    }
}
