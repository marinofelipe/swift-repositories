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
                
        self.activityIndicator.stopAnimating()
        repositoriesViewModel.title = "Swift Repositories"
        
        //repos mock
        self.repositories = []
        for index in 0...22 {
            var repository = Repository()
            repository.name = "Nome \(index)"
            repository.description = "Decsription"
            repository.forksCount = "10"
            repository.starsCount = "3"
            repository.owner?.name = "alamo"
            repository.owner?.imageUrl = ""
            
            repositories?.append(repository)
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
