//
//  TimerTests.swift
//  ExampleTests
//
//  Created by Mars Scala on 2020/11/12.
//

import XCTest

@testable import Example

class TimerTests: XCTestCase {

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

    func testTimerRepeatPass() {
        let queue = DispatchQueue(label: "com.example.timer")
        let timerException = self.expectation(description: "Timer Repeat")

        var repeatedTimes = 0
        let timer = Example.Timer(timeout: 5.0, repeat: true, completion: {
            repeatedTimes += 1
            print(repeatedTimes)
            if repeatedTimes >= 5 {
                timerException.fulfill()
            }
        }, queue: queue)
        timer.start()
        self.waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
