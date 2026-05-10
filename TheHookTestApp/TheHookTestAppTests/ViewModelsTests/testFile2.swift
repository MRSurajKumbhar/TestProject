//
//  testFile2.swift
//  TheHookTestApp
//
//  Created by Suraj Kumbhar on 10/05/26.
//

import XCTest
@testable import TheHookTestApp // Replace with your actual project name

final class testFile2Tests: XCTestCase {
    
    var viewModel: testFile2!

    override func setUp() {
        super.setUp()
        // Initialize the ViewModel before every test
        viewModel = testFile2()
    }

    // MARK: - Update Tests
    
    func testUpdateTestString() {
        // Given: The initial state
        XCTAssertEqual(viewModel.testFile2String, "")
        
        // When: We call the update function
        viewModel.updateTestStringtestFile2()
        
        // Then: The string should match our expected output
        XCTAssertEqual(viewModel.testFile2String, "Testing the test")
    }


}

