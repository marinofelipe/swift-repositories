//
//  BaseViewController.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/3/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

class RepositoryListingViewController: UIViewController {
    
    //repositories
    var repositoriesViewModel = RepositoriesViewModel()
    var repositories: [Repository]?
    var filteredRepositories: [Repository]?
    @IBOutlet weak var collectionView: UICollectionView!
    
    //custom views
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyListLabel: UILabel!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configCollectionViewLayout()
        configSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: CollectionView config
    private func configCollectionViewLayout() {
        let layout = CustomGridFlowLayout()
        layout.delegate = self
        collectionView.collectionViewLayout = layout
    }
    
    // MARK: Search config
    private func configSearch() {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
            let searchController = UISearchController(searchResultsController: nil)
            navigationItem.searchController = searchController
            
            searchController.searchBar.placeholder = repositoriesViewModel.searchPlaceholder
            searchController.searchBar.keyboardType = UIKeyboardType.asciiCapable
            searchController.searchBar.delegate = self
            self.definesPresentationContext = true
            
            let cancelButtonAttributes: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.black]
            UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [NSAttributedStringKey : AnyObject], for: UIControlState.normal)
            UITextField.appearance().tintColor = .black
        } else {
            //TODO: add search on earlier versions
        }
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

// MARK: UICollectionViewDataSource
extension RepositoryListingViewController: UICollectionViewDataSource {
    
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
extension RepositoryListingViewController: UISearchBarDelegate {
    
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
        if searchBar.text == "" {
            filteredRepositories = nil
        }
        collectionView.reloadData()
    }
    
    // MARK: Search Bar Actions    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        collectionView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredRepositories = nil
        collectionView.reloadData()
    }
}

extension RepositoryListingViewController: GridHeightLayoutDelegate {
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
