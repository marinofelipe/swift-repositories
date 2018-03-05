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
    var viewModel = RepositoryListingViewModel()
    var repositories: [Repository]? {
        didSet {
            // TODO: Save Repositories for offline access
            collectionView.reloadData()
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    var searchingFilter: String?
    
    //custom views
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyListLabel: UILabel!
    
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
            
            if let ownerImageUrl = repository?.ownerImageUrl {
                cell.imageView.load(stringUrl: ownerImageUrl)
            }
            cell.nameLabel.text = repository?.name
            cell.descriptionLabel.text = repository?.description
            cell.forksCountLabel.text = repository?.forksCount
            cell.starsCountLabel.text = repository?.starsCount
            cell.ownerUsernameLabel.text = repository?.ownerUsername
            
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
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchingFilter = nil
        collectionView.reloadData()
    }
}

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

extension RepositoryListingViewController {
    func showSnackBar(with message: String, theme: Theme = .error) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(theme)
        view.configureDropShadow()
        
        let title = theme == .warning ? "Warning" : "Error"
        view.configureContent(title: title, body: message)
        view.button?.isHidden = true
        
        SwiftMessages.show(view: view)
    }
}
