//
//  BaseViewController.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/3/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit
import SwiftMessages

class RepositoryListingViewController: UIViewController {
    
    //repositories
    var viewModel = RepositoriesListViewModel()
    @IBOutlet weak var collectionView: UICollectionView!
    
    var searchingFilter: String?
    
    //custom views
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyListLabel: UILabel!
    
    let animationController = AnimatedTransitioningController()
    var cellImageView = UIImageView()
    var imageFrameOnMainView = CGRect.zero
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titlelessBackButton()
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
            
            searchController.searchBar.placeholder = viewModel.searchPlaceholder
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
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.pullRequests, let pullRequestsVC = segue.destination as? PullRequestsViewController {
            var repository: RepositoryViewModel?
            let selectedIndex = collectionView.indexPathsForSelectedItems?.first?.item
            
            guard selectedIndex != nil else { return }
            
            if let filter = searchingFilter {
                repository = viewModel.repositories!.filter({ $0.name?.range(of: filter) != nil })[selectedIndex!]
            } else {
                repository = viewModel.repositories![selectedIndex!]
            }
            
            pullRequestsVC.repository = repository
        }
    }
}

// MARK: UICollectionViewDelegate
extension RepositoryListingViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? RepositoryCollectionViewCell {
            cellImageView = cell.imageView
            imageFrameOnMainView = self.view.convert(cell.imageView.frame, from: cell.ownerView)
        }
        
        performSegue(withIdentifier: Constants.Segue.pullRequests, sender: self)
    }
}

// MARK: UICollectionViewDataSource
extension RepositoryListingViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let filter = searchingFilter {
            return viewModel.repositories?.filter({ $0.name?.range(of: filter) != nil }).count ?? 0
        }
        return viewModel.repositories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifier.Cell.repository, for: indexPath) as? RepositoryCollectionViewCell {
            
            var repository: RepositoryViewModel?
            if let filter = searchingFilter {
                repository = viewModel.repositories!.filter({ $0.name?.range(of: filter) != nil })[indexPath.item]
            } else {
                repository = viewModel.repositories![indexPath.item]
            }
            
            cell.setup(with: repository)
            
            return cell
        }
        
        assertionFailure("identifier for Constants.Identifier.Cell.repository doesn't match with RepositoryCollectionViewCell class or nib not registered")
        return UICollectionViewCell()
    }
}

// MARK: UISearchBarDelegate
extension RepositoryListingViewController: UISearchBarDelegate {
    
    // MARK: Search Bar Text editing
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText != "" else {
            searchingFilter = nil
            collectionView.reloadData()
            return
        }
        searchingFilter = searchText
        collectionView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            searchingFilter = nil
        }
        collectionView.reloadData()
    }
    
    // MARK: Search Bar Actions
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        collectionView.reloadData()
        searchBar.resignFirstResponder()
        self.collectionView.becomeFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchingFilter = nil
        collectionView.reloadData()
    }
}

// MARK: GridHeightLayoutDelegate
extension RepositoryListingViewController: GridHeightLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForCellAt indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        
        var string: String? = ""
        if let filter = searchingFilter {
            string = viewModel.repositories?.filter({ $0.name?.range(of: filter) != nil })[indexPath.item].description
        } else {
            string = viewModel.repositories![indexPath.item].description
        }
        
        let attributedString = NSAttributedString(string: string ?? "", attributes: [.font : UIFont(name: "Avenir-Light", size: 15)!])
        let boundingRect = attributedString.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        
        var height = boundingRect.height
        height += 10 + 10 + 30 + 15 + 20 //margins and other fixed cell heights
        return height
    }
}
