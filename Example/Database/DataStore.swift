//
//  DataStore.swift
//  Example
//
//  Created by Mars Scala on 2020/11/13.
//

import Foundation
import SQLite
import SQLite3

class DataStore {
    private let tableName = "key_value"
    private let connection: Connection
    init?(url: URL) throws {
        var directoryURL = url.absoluteURL
        directoryURL.deleteLastPathComponent()
        if !FileManager.default.fileExists(atPath: directoryURL.path) {
            try FileManager.default.createDirectory(at: directoryURL,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        }
        self.connection = try Connection(url.path)
    }

    func create(table handle: () -> String) throws -> Statement {
        return try connection.run(handle())
    }

    func insert(_ row: [SQLite.Setter], into table: Table) throws -> Int64 {
        return try connection.run(table.insert(row))
    }

    func insert(format sql: String, _ rows: [[String: Binding?]], into table: Table) throws {
//        let table = Table(tableName)
//        let keyColum = Expression<String>("key")
//        let valueColum = Expression<Data>("value")
//        let createAtColum = Expression<Int64>("createAt")
//        let stmt = try db.prepare(<#T##statement: String##String#>, <#T##bindings: Binding?...##Binding?#>)
//        for row in values {
//            var bindings = [String: Binding]()
//            for colum in row {
//                bindings
//                stmt.bind(<#T##values: Binding?...##Binding?#>)
//            }
//        }
//        keyColum <- key, valueColum <- value, createAtColum <- Int64(Date().timeIntervalSince1970 * 1000)
        try connection.transaction { [unowned connection] in
            let stmt = try connection.prepare(sql)
            for row in rows {
                try stmt.run(row)
            }
        }
    }

    func justOne<E>(query handle: () -> Table, binding: (Row) -> E) -> E? {
        do {
            var results = [E]()
            var rows = try connection.prepare(handle())
            rows = rows.dropFirst()
            for value in rows {
                let result = binding(value)
                results.append(result)
            }
            return results.first
        } catch {
            print(error)
            return nil
        }
    }

    func query<E>(query handle: () -> Table, binding: (Row) -> E) throws -> [E] {
        var results = [E]()
        for value in try connection.prepare(handle()) {
            let result = binding(value)
            results.append(result)
        }
        return results
    }
}
