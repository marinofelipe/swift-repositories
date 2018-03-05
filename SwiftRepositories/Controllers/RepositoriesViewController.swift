//
//  RepositoriesViewController.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/1/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

class RepositoriesViewController: RepositoryListingViewController {
    
    var cellSnapshotImageView: UIImageView?
    var draggingCell: UICollectionViewCell?
    var draggingRepository: Repository?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        activityIndicator.stopAnimating()
        viewModel.title = "Swift Repositories"
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(RepositoriesViewController.handleLongPress))
        view.addGestureRecognizer(longPress)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Long Press
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        let collectionTouchedPoint = gesture.location(in: self.collectionView)
        let viewTouchedPoint = gesture.location(in: self.view)
        
        if gesture.state == .began {
            if let indexPath = collectionView.indexPathForItem(at: collectionTouchedPoint),
                let cell = collectionView.cellForItem(at: indexPath) as? RepositoryCollectionViewCell {
                
                draggingCell = cell
                if let filter = searchingFilter {
//                    draggingRepository = viewModel.repositories!.filter({ $0.name?.range(of: filter) != nil })[indexPath.item]
                } else {
//                    draggingRepository = viewModel.repositories![indexPath.item]
                }
                
                let cellSnapshot = UIImage.image(ofView: cell)
                
                cellSnapshotImageView = UIImageView(image: cellSnapshot)
                cellSnapshotImageView?.frame = view.convert(cell.frame, from: collectionView)
                cellSnapshotImageView?.alpha = 0.0
                
                self.view.addSubview(cellSnapshotImageView!)
                
                UIView.animate(withDuration: 0.36, animations: {
                    self.cellSnapshotImageView?.center = viewTouchedPoint
                    self.cellSnapshotImageView?.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
                    self.cellSnapshotImageView?.alpha = 0.95
                    self.draggingCell?.alpha = 0.80
                })
            }
        } else if gesture.state == .changed {
            cellSnapshotImageView?.center = viewTouchedPoint
        } else {
            //TODO: Send to other controller
            if let cellSnapshotImageView = cellSnapshotImageView,
                cellSnapshotImageView.frame.origin.x > (view.frame.width - cellSnapshotImageView.frame.width / 2 - 20) {
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.draggingToFavorites()
                    
                    //save sent item as favorite
                }
            }
            
            guard draggingCell != nil else { return }
            UIView.animate(withDuration: 0.36, animations: {
                self.cellSnapshotImageView?.center = self.view.convert(self.draggingCell!.center, from: self.collectionView)
            }, completion: { isFinished in
                self.draggingCell?.alpha = 1.0
                self.cellSnapshotImageView?.removeFromSuperview()
                self.draggingCell = nil
                self.draggingRepository = nil
            })
        }
    }
}
