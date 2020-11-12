//
//  NetworkTests.swift
//  ExampleTests
//
//  Created by Mars Scala on 2020/11/12.
//

import XCTest
@testable import Example

class NetworkTests: XCTestCase {

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

    func testNetworkRequstAction() {
        let except = XCTestExpectation(description: "")
        Network.default.get("/") { data -> [String: Any] in
            guard let obj = (try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)),
                  let jsonObj = obj as? [String: String] else {
                return [String: String]()
            }
            return jsonObj
        }
            success: { (value, _) in
                print(value.keys)
                XCTAssertTrue(value.count > 0)
                except.fulfill()
        } failed: { _, error in
            XCTAssertThrowsError(error)
            except.fulfill()
        }
        self.wait(for: [except], timeout: 5.0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
