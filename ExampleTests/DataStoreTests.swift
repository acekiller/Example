//
//  DataStoreTests.swift
//  ExampleTests
//
//  Created by Mars Scala on 2020/11/13.
//

import XCTest
@testable import Example

class DataStoreTests: XCTestCase {

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

//    var table = Table(tableName)
//    let valueColum = Expression<Data>("value")
//    let keyColum = Expression<String>("key")
//    let createAtColum = Expression<Int64>("createAt")
//    table = table.order(createAtColum.desc).limit(1).select([keyColum, valueColum])

    func testCreateTable() throws {
        let dbPath = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("store.db")
        guard let dataStore = try DataStore(url: dbPath) else {
            XCTFail("db create failed")
            return
        }
        let stmt = try? dataStore.create(table: KeyValue.createSQL)
        XCTAssertNotNil(stmt)
    }

    func testInsert() throws {
        let dbPath = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("store.db")
        guard let dataStore = try? DataStore(url: dbPath) else {
            XCTFail("db create failed")
            return
        }

        _ = try dataStore.insert(KeyValue.encode(key: "Hello", value: "你好".data(using: .utf8)!), into: KeyValue.table)
        _ = try dataStore.insert(KeyValue.encode(key: "Welcome", value: "欢迎".data(using: .utf8)!), into: KeyValue.table)
        _ = try dataStore.insert(KeyValue.encode(key: "China", value: "中国".data(using: .utf8)!), into: KeyValue.table)
    }

    func testQueryLatestValue() {
        let dbPath = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("store.db")
        guard let dataStore = try? DataStore(url: dbPath) else {
            XCTFail("db create failed")
            return
        }
        let result = dataStore.justOne(query: KeyValue.latest, binding: {
            KeyValue.keyValueRow(row: $0)
        })
        print("\(String(describing: result?.key)):\(result?.value?.count ?? 0)")
        XCTAssertNotNil(result)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
