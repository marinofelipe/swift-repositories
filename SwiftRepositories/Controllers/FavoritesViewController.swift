//
//  FavoritesViewController.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/3/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

class FavoritesViewController: RepositoryListingViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.stopAnimating()
        viewModel.title = "Favorites"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchFavorites()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Fetch favorites
    func fetchFavorites() {
        viewModel.repositories = RepositoryEntity.fetchAll(favorites: true)?.map({ RepositoryViewModel(repositoryEntity: $0) })
        collectionView.reloadData()
    }
}
