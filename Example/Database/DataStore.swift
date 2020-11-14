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
        try connection.transaction { [unowned connection] in
            let stmt = try connection.prepare(sql)
            for row in rows {
                try stmt.run(row)
            }
        }
    }

    func justOne<E>(query handle: () -> Table, binding: (Row) -> E) throws -> E? {
        var results = [E]()
        for value in try connection.prepare(handle()) {
            let result = binding(value)
            results.append(result)
        }
        return results.first
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
