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
    
    @IBOutlet weak var noOpenPullRequestsLabel: UILabel!
    @IBOutlet weak var noClosedPullRequestsLabel: UILabel!
    
    var repository: RepositoryViewModel?
    fileprivate var viewModel = PullRequestsListViewModel() {
        didSet {
            openPullRequests = viewModel.pullRequests?.filter({ $0.state == PullRequestState.open.rawValue })
            closedPullRequests = viewModel.pullRequests?.filter({ $0.state == PullRequestState.closed.rawValue })
        }
    }
    var openPullRequests: [PullRequestViewModel]? {
        didSet {
            if let openPullRequests = openPullRequests, openPullRequests.count > 0 {
                noOpenPullRequestsLabel.isHidden = true
            } else {
                noOpenPullRequestsLabel.isHidden = false
            }
        }
    }
    var closedPullRequests: [PullRequestViewModel]? {
        didSet {
            if let closedPullRequests = closedPullRequests, closedPullRequests.count > 0 {
                noClosedPullRequestsLabel.isHidden = true
            } else {
                noClosedPullRequestsLabel.isHidden = false
            }
        }
    }
    var showingPullRequests: [PullRequestViewModel]? {
        if openBarButton.isSelected {
            return openPullRequests
        } else {
            return closedPullRequests
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = viewModel.title
        titlelessBackButton()
        improveBarButtonsLayout() //add count to them
        configCollectionViews()
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
                    self.activityIndicator.stopAnimating()
                    
                    if response?.statusCode == .success {
                        self.activityIndicator.stopAnimating()
                        
                        guard response?.pullRequests != nil else { return }
                        
                        if completion != nil {
                            self.viewModel.pullRequests = nil
                        }
                        
                        self.viewModel.pullRequests = response?.pullRequests
                        self.openedCollectionView.reloadData()
                        completion?()
                    } else {
                        var theme: Theme = .error
                        if response?.statusCode == .offline {
                            theme = .warning
                        }
                        completion?()
                        self.showSnackBar(with: response?.message ?? Constants.Message.repositoriesError, theme: theme)
                    }
                }
            })
        }
    }
    
    // MARK: Labels
    func improveBarButtonsLayout() {
        openBarButton.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: headerToolbar.frame.width / 2, height: headerToolbar.frame.height)
        
        closedBarButton.frame = CGRect(x: headerToolbar.frame.width / 2, y: view.frame.origin.y, width: headerToolbar.frame.width / 2, height: headerToolbar.frame.height)
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
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.openInBrowser {
            if let destination = segue.destination as? WebViewController {
                var indexPath: IndexPath?
                if openBarButton.isSelected {
                    indexPath = openedCollectionView.indexPathsForSelectedItems?.first
                } else {
                    indexPath = closedCollectionView.indexPathsForSelectedItems?.first
                }
                    
                let pullRequest = self.showingPullRequests![indexPath?.item ?? 0]
                let url = URL(string: pullRequest.url ?? "")
                destination.url = url
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
        guard showingPullRequests != nil else { return 0 }
        return showingPullRequests!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifier.Cell.pullRequest, for: indexPath) as? PullRequestsCollectionViewCell,
            showingPullRequests != nil {
            
            let pullRequest = showingPullRequests![indexPath.item]
        
            cell.setup(with: pullRequest)
            
            return cell
        }
        
        assertionFailure("identifier for Constants.Identifier.Cell.repository doesn't match with RepositoryCollectionViewCell class or nib not registered")
        return UICollectionViewCell()
    }
}

extension PullRequestsViewController: GridHeightLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForCellAt indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        
        guard showingPullRequests != nil else { return  0.0 }
        let pullRequest = showingPullRequests![indexPath.item]
        
        var string: String? = ""
        string = pullRequest.description
        
        let attributedString = NSAttributedString(string: string ?? "", attributes: [.font : UIFont(name: "Avenir-Light", size: 12)!])
        let boundingRect = attributedString.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        
        var height = boundingRect.height
        height += 10 + 23 + 17.5 + 11 + 30 + 5 //margins and other fixed cell heights
        return height
    }
}

// MARK: UIScrollViewDelegate
extension PullRequestsViewController: UIScrollViewDelegate {
    
    func scrollToColletion(atIndex index: Int) {
        scrollView.contentOffset = CGPoint(x: scrollView.frame.size.width * CGFloat(index), y: 0)
    }
}
