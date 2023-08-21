//
//  LookViewController.swift
//  HeartHub
//
//  Created by 이태영 on 2023/07/20.
//

import UIKit

final class LookViewController: UIViewController {
    private let lookCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        return collectionView
    }()
    
    private var articles: [Article] = [] {
        didSet {
            lookCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLookCollectionView()
        configureSubview()
        configureLayout()
    }
}

// MARK: UICollectionView Delegate FlowLayout Implementation
extension LookViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = view.frame.width
        let estimateHeight = view.frame.height
        let size = CGRect(x: 0, y: 0, width: width, height: estimateHeight)
        let dummyCell = LookCell(frame: size)
        
        dummyCell.configureCell(articles[indexPath.row])
        dummyCell.layoutIfNeeded()
        
        var height = dummyCell.fetchAdjustedHeight()
        
        if height > 542 {
            height = 542
        }
        
        return CGSize(width: width, height: height)
    }
}

// MARK: UICollectionView DataSource Implementation
extension LookViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return articles.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: LookCell.reuseIdentifier,
            for: indexPath) as? LookCell
        else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(articles[indexPath.row])
        cell.delegate = self
        
        return cell
    }
}

// MARK: Configure CollectionView
extension LookViewController {
    private func configureLookCollectionView()  {
        lookCollectionView.dataSource = self
        lookCollectionView.delegate = self
        lookCollectionView.register(
            LookCell.self,
            forCellWithReuseIdentifier: LookCell.reuseIdentifier
        )
    }
}

// MARK: Community Cell Delegate Implementation
extension LookViewController: CommunityCellDelegate {
    func didTapUserProfile() {
        
    }
    
    func didTapPostOption() {
        
    }
    
    func didTapThumbButton() {
        
    }
    
    func didTapCommentButton() {
        let commentViewController = CommentViewController()
        commentViewController.modalPresentationStyle = .custom
        commentViewController.transitioningDelegate = PanModalTransitioningDelegate.shared
        
        present(commentViewController, animated: true)
    }
    
    func didTapHeartButton() {
        
    }
}

// MARK: Configure UI
extension LookViewController {
    private func configureSubview() {
        view.addSubview(lookCollectionView)
        lookCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            // MARK: lookCollectionView Constraint
            lookCollectionView.topAnchor.constraint(
                equalTo: safeArea.topAnchor
            ),
            lookCollectionView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor
            ),
            lookCollectionView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor
            ),
            lookCollectionView.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor
            ),
        ])
    }
}
