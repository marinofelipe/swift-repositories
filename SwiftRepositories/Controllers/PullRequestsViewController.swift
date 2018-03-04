//
//  PullRequestsViewController.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/1/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

class PullRequestsViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    //to viewModel
    var repositoryName: String!
    var repositoryOwner: String!
    var nameAndLastName: String!
    fileprivate var pullRequests: [PullRequest]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titlelessBackButton()

        pullRequests = []
        //mock pull requests
        for _ in 0...10 {
            let pullRequest = PullRequest(title: "Pull", body: "dae asd asd ae fas fafe fasf e faefajshfk jaksjhfk jahskfhk ajhekjhfk jahskfhk ashfjhei hfaewkf ", date: "03/04/2018")
            pullRequests?.append(pullRequest)
        }
        
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup Table View
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    

    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.openInBrowser {
            if let destination = segue.destination as? WebViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let pullRequest = self.pullRequests![indexPath.row]
//                    let url = URL(string: pullRequest.url)
//                    destination.url = url
                    
                }
            }
        }
    }
}

// MARK: - TableView Delegate
extension PullRequestsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }
}

// MARK: - TableView DataSource
extension PullRequestsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pullRequests?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: Constants.Identifier.Cell.pullRequest, for: indexPath) as? PullRequestTableViewCell {
        
            let pullRequest = self.pullRequests![indexPath.row]
            
//            let formattedDate = Date.fromString(pullRequest.date)
//            let stringDate = formattedDate.convertToLongString()
            
            cell.titleLabel.text = pullRequest.title
            cell.bodyLabel.text = pullRequest.body
            cell.ownerUsernameLabel.text = pullRequest.ownerNick
//            cell.dateLabel.text = stringDate
            cell.ownerNameLabel.text = nameAndLastName
            cell.ownerImageView.image = #imageLiteral(resourceName: "star")
            
            return cell
        }
        
        assertionFailure("identifier for Constants.Identifier.Cell.pullRequest doesn't match with PullRequestTableViewCell class or nib not registered")
        return UITableViewCell()
    }
}

