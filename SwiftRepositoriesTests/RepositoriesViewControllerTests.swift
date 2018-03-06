//
//  SwiftRepositoriesTests.swift
//  SwiftRepositoriesTests
//
//  Created by Felipe Lefèvre Marino on 3/1/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import XCTest
@testable import SwiftRepositories

class RepositoriesViewControllerTests: XCTestCase {
    
    var underTestController: RepositoriesViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        underTestController = storyboard.instantiateViewController(withIdentifier: Constants.Identifier.Storyboard.repositories) as! RepositoriesViewController
        
        UIApplication.shared.keyWindow?.rootViewController = underTestController
        
        XCTAssertNotNil(underTestController.preloadView())
    }
    
    override func tearDown() {
        underTestController = nil
        super.tearDown()
    }
    
    // MARK: After loading states
    func testIfViewsAreCorrectlyConfigured() {
        XCTAssertEqual(underTestController.emptyListLabel.isHidden, true)
        XCTAssertNotNil(underTestController.collectionView)
        XCTAssertEqual(underTestController.title, "Swift Repositories")
        XCTAssertNotNil(underTestController.searchBar)
    }

    func testCollectionAfterLoading() {
        XCTAssertEqual(underTestController.collectionView.numberOfItems(inSection: 0), 0)
    }
    
    // TODO: test after fetching
    
    // MARK: Search
    func testSearchingWithInvalidRepositoryName() {
        underTestController.searchBar(UISearchBar(), textDidChange: "& 2 8 s23 as 23")
        XCTAssertEqual(underTestController.collectionView.numberOfItems(inSection: 0), 0)
    }
    
    func testSearchingWithValidRepositoryName() {
        if let firstRepositoryName = underTestController.viewModel.repositories?.first?.name {
            underTestController.searchBar(UISearchBar(), textDidChange: firstRepositoryName)
            XCTAssertEqual(underTestController.collectionView.numberOfItems(inSection: 0), 1)
        }
    }
    
    func testSearchWithCommonPrefix() {
        let repositories = [Repository(name: "Test 1"), Repository(name: "Test 2"), Repository(name: "Test 3"), Repository(name: "4")]
        underTestController.viewModel.repositories = repositories.map({ return RepositoryViewModel(repository: $0) })
        underTestController.collectionView.reloadData()
        
        underTestController.searchBar(UISearchBar(), textDidChange: "Test")
        XCTAssertEqual(underTestController.collectionView.numberOfItems(inSection: 0), 3)
    }

    // MARK: API Performance
    func testAPIperformance() {
        self.measure {
            // repositories call
        }
    }
}
