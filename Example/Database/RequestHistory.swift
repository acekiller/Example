//
//  RequestHistory.swift
//  Example
//
//  Created by Mars Scala on 2020/11/14.
//

import Foundation
import SQLite

struct RequestHistory {
    var key: String!
    var value: String!

    init(key: String, value: String) {
        self.key = key
        self.value = value
    }
}

extension RequestHistory: TableCoding {
    static let table = Table("history")
    static let idColum = Expression<Int64>("id")
    static let keyColumn = Expression<String>("key")
    static let valueColumn = Expression<String>("value")
    static let createAtColumn = Expression<Int64>("createAt")

    static func createSQL() -> String {
        return table.create(ifNotExists: true, block: {
            $0.column(idColum, primaryKey: .autoincrement)
            $0.column(keyColumn, unique: true)
            $0.column(valueColumn)
            $0.column(createAtColumn)
        })
    }

    static func encode(key: String, value: String) -> [Setter] {
        return [keyColumn <- key, valueColumn <- value, createAtColumn <- Int64(Date().timeIntervalSince1970 * 1000)]
    }

    static func keyValueRow(row: Row) -> RequestHistory {
        return RequestHistory(key: row[RequestHistory.keyColumn], value: row[RequestHistory.valueColumn])
    }

    static func allRecords() -> Table {
        let tbl = self.table
        return tbl.order(createAtColumn.asc).select(keyColumn, valueColumn, createAtColumn)
    }
}
