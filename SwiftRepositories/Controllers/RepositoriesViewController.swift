//
//  RepositoriesViewController.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/1/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

class RepositoriesViewController: BaseViewController {
    
    var repositories: [Repository]?
    var filteredRepositories: [Repository]?
    var repositoriesViewModel = RepositoriesViewModel()
    
    @IBOutlet weak var searchBarButtonItem: UIBarButtonItem!
    var searchBarButtonReplacableItem: UIBarButtonItem?
    var searchController: UISearchController?
    var searchBar: UISearchBar?
    
    var cellSnapshotImageView: UIImageView?
    var draggingCell: UICollectionViewCell?
    var draggingRepository: Repository?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionView.collectionViewLayout as? CustomGridFlowLayout {
            layout.delegate = self
        }
        
        //repos mock
        repositories = []
        for index in 0...22 {
            var repository = Repository()
            repository.name = "Nome \(index)"
            repository.description = "Descricao maior asd asd asd asd asd asda sda dasd as asd asd asd asd asdas dasd asd asd asdas dasd asd asd asd asda sdasd asd ashudh uahsdh uasduahsudhu asdahsudh ausdhu hasudhu ashdu ahsudh uashdu hasudhu ahsdu ahsudh uadahsdu hausuashdu husdhu aduahsud hasudhausdhu aduasdadasdhausduashd as"
            repository.forksCount = "10"
            repository.starsCount = "3"
            repository.owner?.name = "alamo"
            repository.owner?.imageUrl = ""
            
            repositories?.append(repository)
        }
        
        //search
        searchBarButtonReplacableItem = searchBarButtonItem
        
        self.searchBar = UISearchBar()
        searchBar?.keyboardType = UIKeyboardType.asciiCapable
        searchBar?.delegate = self
        searchBar?.showsCancelButton = true
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
    
    // MARK: Actions
    @IBAction func searchAction(sender: UIBarButtonItem) {
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.titleView = self.searchBar!
        self.searchBar?.alpha = 0.0
        
        UIView.animate(withDuration: 0.36, animations: {
            self.searchBar?.alpha = 1.0
        }, completion: { isFinished in
            self.searchBar?.becomeFirstResponder()
        })
    }
}

// MARK: UICollectionViewDelegate
extension RepositoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        //TODO: add row animation
    }
}

// MARK: UICollectionViewDataSource
extension RepositoriesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let filteredRepositories = filteredRepositories {
            return filteredRepositories.count
        }
        return repositories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifier.Cell.repository, for: indexPath) as? RepositoryCollectionViewCell {
            
            var repository: Repository?
            if let filteredRepositories = filteredRepositories {
                repository = filteredRepositories[indexPath.item]
            } else {
                repository = repositories![indexPath.item]
            }
            
            
            cell.imageView.image = #imageLiteral(resourceName: "star")
            cell.nameLabel.text = repository?.name
            cell.descriptionLabel.text = repository?.description
            cell.forksCountLabel.text = repository?.forksCount
            cell.starsCountLabel.text = repository?.starsCount
            cell.ownerNameLabel.text = repository?.owner?.name
            
            //            cell.backgroundColor = UIColor.blue
            
            return cell
        }
        
        assertionFailure("")
        return UICollectionViewCell()
    }
}

// MARK: UISearchBarDelegate
extension RepositoriesViewController: UISearchBarDelegate {
    
    // MARK: Search Bar Text editing
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText != "" else {
            filteredRepositories = nil
            collectionView.reloadData()
            return
        }
        filteredRepositories = repositories?.filter({ $0.name?.range(of: searchText) != nil })
        collectionView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        filteredRepositories = nil
        collectionView.reloadData()
    }
    
    // MARK: Search Bar Actions
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredRepositories = nil
        UIView.animate(withDuration: 0.36, animations: {
            self.searchBar?.alpha = 0.0
        }, completion: { isFinished in
            self.searchBar?.resignFirstResponder()
            self.navigationItem.rightBarButtonItem = self.searchBarButtonReplacableItem
            
            UIView.animate(withDuration: 0.36, animations: {
                self.navigationItem.titleView = nil
                self.title = self.repositoriesViewModel.title
            }, completion: { isFinished in
                self.searchBar?.resignFirstResponder()
                self.collectionView.reloadData()
            })
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar?.resignFirstResponder()
    }
}

extension RepositoriesViewController: GridHeightLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForCellAt indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        
        var string: String? = ""
        if let filteredRepositories = filteredRepositories {
            string = filteredRepositories[indexPath.item].description
        } else {
            string = repositories![indexPath.item].description
        }
        
        let attributedString = NSAttributedString(string: string ?? "", attributes: [.font : UIFont(name: "Avenir-LightOblique", size: 12)!])
        let boundingRect = attributedString.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        
        var height = boundingRect.height
        height += 10 + 10 + 30 + 15 + 20 //margins and other fixed cell heights
        return height
    }
}
