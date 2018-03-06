//
//  PullRequestsViewController.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/1/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit
import SwiftMessages

class PullRequestsViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var openBarButton: UIButton!
    @IBOutlet weak var closedBarButton: UIButton!
    
    @IBOutlet weak var openedCollectionView: UICollectionView!
    @IBOutlet weak var closedCollectionView: UICollectionView!
    
    @IBOutlet weak var headerToolbar: UIToolbar!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var selectedBar: UIView!
    @IBOutlet var selectedBarLeadingConstraint: NSLayoutConstraint!
    
    var repository: RepositoryViewModel?
    fileprivate var viewModel = PullRequestsListViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = viewModel.title
        titlelessBackButton()
        improveBarButtonsAlingment() //add count to them
        configCollectionViews()
        
        guard repository != nil else {
            //message
            return
        }
        fetchPullRequests()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Data
    private func fetchPullRequests(completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .userInteractive).async {
            PullRequestsHandler.getAll(fromRepository: self.repository, completion: { response in
                DispatchQueue.main.async {
                    if response?.statusCode == .success {
                        self.activityIndicator.stopAnimating()
                        
                        guard response?.pullRequests != nil else { return }
                        
                        if completion != nil {
                            self.viewModel.pullRequests = nil
                        }
                        
                        self.viewModel.pullRequests = response?.pullRequests
                        self.openedCollectionView.reloadData()
                        self.closedCollectionView.reloadData()
                        completion?()
                    } else {
                        if self.viewModel.pullRequests == nil {
                            //                            self.emptyListLabel.isHidden = false
                        }
                        
                        var theme: Theme = .error
                        if response?.statusCode == .offline {
                            theme = .warning
                        }
                        completion?()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.46, execute: {
                            //                            self.showSnackBar(with: response?.message ?? Constants.Message.repositoriesError, theme: theme)
                        })
                    }
                }
            })
        }
    }
    
    // MARK: Labels
    func improveBarButtonsAlingment() {
        openBarButton.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: headerToolbar.frame.width / 2, height: headerToolbar.frame.height)
        
        closedBarButton.frame = CGRect(x: headerToolbar.frame.width / 2, y: view.frame.origin.y, width: headerToolbar.frame.width / 2, height: headerToolbar.frame.height)
        closedBarButton.setImage(nil, for: .selected)
    }
    
    // MARK: Actions
    @IBAction func touchedButton(_ sender: Any) {
        if let senderButton = sender as? UIButton {
            let isSelecting = !senderButton.isSelected
            if isSelecting {
                openBarButton.isSelected = false
                closedBarButton.isSelected = false
                senderButton.isSelected = true
                animate(touchOn: senderButton)
            }
        }
    }
    
    private func animate(touchOn button: UIButton!) {
        let index = button.tag
        selectedBarLeadingConstraint.constant = CGFloat(index) * self.view.frame.size.width / 2
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.scrollToColletion(atIndex: index)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: - Config Collection Views
    private func configCollectionViews() {
        let layout = CustomGridFlowLayout()
        layout.delegate = self
        openedCollectionView.collectionViewLayout = layout
        closedCollectionView.collectionViewLayout = layout
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.openInBrowser {
            if let destination = segue.destination as? WebViewController {
                //                if let indexPath = tableView.indexPathForSelectedRow {
                //                    let pullRequest = self.pullRequests![indexPath.row]
                ////                    let url = URL(string: pullRequest.url)
                ////                    destination.url = url
                //
                //                }
            }
        }
    }
}

// MARK: UICollectionViewDataSource
extension PullRequestsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pullRequests?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifier.Cell.pullRequest, for: indexPath) as? PullRequestsCollectionViewCell {
            
            let pullRequest = viewModel.pullRequests![indexPath.item]
            cell.setup(with: pullRequest)
            
            return cell
        }
        
        assertionFailure("identifier for Constants.Identifier.Cell.repository doesn't match with RepositoryCollectionViewCell class or nib not registered")
        return UICollectionViewCell()
    }
}

extension PullRequestsViewController: GridHeightLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForCellAt indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        
        var string: String? = ""
        string = viewModel.pullRequests![indexPath.item].description
        
        let attributedString = NSAttributedString(string: string ?? "", attributes: [.font : UIFont(name: "Avenir-Light", size: 15)!])
        let boundingRect = attributedString.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        
        var height = boundingRect.height
        height += 10 + 23 + 16.5 + 11 + 30 //margins and other fixed cell heights
        return height
    }
}

// MARK: UIScrollViewDelegate
extension PullRequestsViewController: UIScrollViewDelegate {
    
    func scrollToColletion(atIndex index: Int) {
        scrollView.contentOffset = CGPoint(x: scrollView.frame.size.width * CGFloat(index), y: 0)
    }
}
