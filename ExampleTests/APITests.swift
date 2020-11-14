//
//  APITests.swift
//  ExampleTests
//
//  Created by Mars Scala on 2020/11/12.
//

import XCTest
@testable import Example

class APITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testAPIPath() throws {
        let baseURL = URL(string: "http://api.github.com/")
        let targetURL = URL(string: "http://api.github.com/hello/am")
        let url = Network.API.relative("/hello/am").url(baseURL: baseURL)
        XCTAssertEqual(url?.absoluteURL, targetURL?.absoluteURL)
    }

    func testAPIRoot() throws {
        let baseURL = URL(string: "http://api.github.com/")
        let url = Network.API.relative("/").url(baseURL: baseURL)
        XCTAssertEqual(url?.absoluteURL, baseURL?.absoluteURL)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
