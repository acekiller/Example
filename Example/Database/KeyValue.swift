//
//  KeyValue.swift
//  Example
//
//  Created by Mars Scala on 2020/11/13.
//

import Foundation
import SQLite

struct KeyValue {
    var key: String!
    var value: Data?

    init(key: String, value: Data?) {
        self.key = key
        self.value = value
    }
}

extension KeyValue: TableCoding {
    static let table = Table("key_value")
    static let idColum = Expression<Int64>("id")
    static let keyColumn = Expression<String>("key")
    static let valueColumn = Expression<Data?>("value")
    static let createAtColumn = Expression<Int64>("createAt")

    static func createSQL() -> String {
        return table.create(ifNotExists: true, block: {
            $0.column(idColum, primaryKey: .autoincrement)
            $0.column(keyColumn, unique: true)
            $0.column(valueColumn)
            $0.column(createAtColumn)
        })
    }

    static func encode(key: String, value: Data) -> [Setter] {
        return [keyColumn <- key, valueColumn <- value, createAtColumn <- Int64(Date().timeIntervalSince1970 * 1000)]
    }

    static func keyValueRow(row: Row) -> KeyValue {
        return KeyValue(key: row[KeyValue.keyColumn], value: row[KeyValue.valueColumn])
    }

    static func latest() -> Table {
        let tbl = self.table
        return tbl.order(createAtColumn.desc).select(keyColumn, valueColumn).limit(1)
    }
}
