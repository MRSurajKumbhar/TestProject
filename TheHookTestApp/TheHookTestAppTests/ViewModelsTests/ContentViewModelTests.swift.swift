//
//  ContentViewModelTests.swift.swift
//  TheHookTestApp
//
//  Created by Suraj Kumbhar on 10/05/26.
//

import XCTest
@testable import TheHookTestApp // Replace with your actual project name

final class ContentViewModelTests: XCTestCase {
    
    var viewModel: ContentViewModel!

    override func setUp() {
        super.setUp()
        // Initialize the ViewModel before every test
        viewModel = ContentViewModel()
    }

    override func tearDown() {
        // Clean up after every test
        viewModel = nil
        super.tearDown()
    }

    // MARK: - Update Tests
    
    func testUpdateTestString() {
        // Given: The initial state
        XCTAssertEqual(viewModel.testString, "")
        
        // When: We call the update function
        viewModel.updateTestString()
        
        // Then: The string should match our expected output
        XCTAssertEqual(viewModel.testString, "Testing the test")
    }


}
