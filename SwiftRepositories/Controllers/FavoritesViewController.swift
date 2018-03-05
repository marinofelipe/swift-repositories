//
//  FavoritesViewController.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/3/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

class FavoritesViewController: RepositoryListingViewController {
    
     var addingItem: RepositoryViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.stopAnimating()
        viewModel.title = "Favorites"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let nav = tabBarController?.viewControllers?.first as? UINavigationController,
            let vc = nav.viewControllers.first as? RepositoriesViewController {
            
            addingItem = vc.draggingRepository
            
            
            //TODO:
            //update item as favorite in core data
            //Collection insert row animating
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
