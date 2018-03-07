//
//  RepositoryEntityTests.swift
//  SwiftRepositoriesTests
//
//  Created by Felipe Lefèvre Marino on 3/7/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import XCTest
@testable import SwiftRepositories

class RepositoryEntityTests: XCTestCase {
    
    var viewModel: RepositoryViewModel?
    var model: Repository?
    
    override func setUp() {
        try? RepositoryEntity.deleteAll()
        model = Repository(name: "name")
        super.setUp()
    }
    
    override func tearDown() {
        model = nil
        super.tearDown()
    }
    
    func testIfAEntityIsCreatedWhenInViewModelInit() {
        viewModel = RepositoryViewModel(repository: model!)
        
        let repositories = RepositoryEntity.fetchAll()
        XCTAssertEqual(repositories?.count, 1)
    }
    
    func testIfFetchReturnsExpectedItems() {
        viewModel = RepositoryViewModel(repository: model!)
        viewModel = RepositoryViewModel(id: 99)
        
        let repository = RepositoryEntity.fetch(withId: 99)
        XCTAssertEqual(repository?.id, 99)
    }
}
