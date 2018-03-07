//
//  RepositoriesViewController.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/1/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit
import SwiftMessages

class RepositoriesViewController: RepositoryListingViewController {
    
    var cellSnapshotImageView: UIImageView?
    var draggingCell: UICollectionViewCell?
    var draggingRepository: RepositoryViewModel?
    fileprivate var repositoriesPaging = RepositoriesPaging()
    fileprivate var refreshControl: RefreshControl?
    var didShowNotConnectedSnack: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.stopAnimating()
        setupRefreshControl()
        viewModel.title = "Swift Repositories"
        
        fetchRepositories()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(RepositoriesViewController.handleLongPress))
        view.addGestureRecognizer(longPress)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchSavedRepositories()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Refresh Control
    private func setupRefreshControl() {
        refreshControl = RefreshControl()
        refreshControl?.delegate = self
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl!)
        }
    }
    
    // MARK: Data
    private func fetchRepositories(completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .userInteractive).async {
            RepositoriesHandler.get(atPage: self.repositoriesPaging.currentPage) { response in
                DispatchQueue.main.async {
                    if response?.statusCode == .success {
                        self.activityIndicator.stopAnimating()
                        self.emptyListLabel.isHidden = true
                        self.didShowNotConnectedSnack = false
                        
                        if let total = response?.total, self.repositoriesPaging.totalItems != total {
                            self.repositoriesPaging.totalItems = total
                        }
                        
                        guard response?.repositories != nil else { return }
                        
                        if completion != nil {
                            self.viewModel.repositories = nil
                        }
                        guard self.viewModel.repositories != nil else {
                            self.viewModel.repositories = response?.repositories
                            self.collectionView.reloadData()
                            completion?()
                            return
                        }
                        
                        guard self.repositoriesPaging.currentPage != 1 else { return }
                        
                        if let repositories = response?.repositories {
                            self.viewModel.repositories?.append(contentsOf: repositories)
                            self.collectionView.reloadData()
                        }
                    } else {
                        self.repositoriesPaging.currentPage > 1 ? self.repositoriesPaging.currentPage -= 1 : ()
                        
                        var theme: Theme = .error
                        if response?.statusCode == .offline {
                            theme = .warning
                            
                            self.fetchSavedRepositories()
                        }
                        
                        if self.viewModel.repositories == nil {
                            self.emptyListLabel.isHidden = false
                        }
                        
                        completion?()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.46, execute: {
                            self.showSnackBar(with: response?.message ?? Constants.Message.repositoriesError, theme: theme)
                        })
                    }
                }
            }
        }
    }
    
    private func fetchSavedRepositories() {
        self.viewModel.repositories = RepositoryEntity.fetchAll()?.map({ return RepositoryViewModel(repositoryEntity: $0) })
        self.collectionView.reloadData()
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
                    draggingRepository = viewModel.repositories!.filter({ $0.name?.range(of: filter) != nil })[indexPath.item]
                } else {
                    draggingRepository = viewModel.repositories![indexPath.item]
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
                    self.draggingCell?.alpha = 0.60
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

// MARK: UICollectionViewDelegate
extension RepositoriesViewController {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let referenceItemToNextFetch = (repositoriesPaging.itemsPerPage * repositoriesPaging.currentPage) - 2 //breath
        if indexPath.row >= referenceItemToNextFetch && repositoriesPaging.currentPage < repositoriesPaging.numberOfPages {
            
            guard Reachability.shared.isConnected() else {
                !didShowNotConnectedSnack ? showSnackBar(with: Constants.Message.notConnected, theme: .warning) : ()
                didShowNotConnectedSnack = true
                return
            }
            
            didShowNotConnectedSnack = false
            repositoriesPaging.currentPage += 1
            fetchRepositories()
        }
    }
}

// MARK: RefreshControlDelegate
extension RepositoriesViewController: RefreshControlDelegate {
    func willRefresh() {
        searchingFilter = nil
        repositoriesPaging.currentPage = 1
        fetchRepositories {
            self.refreshControl?.endRefreshing()
        }
    }
}
