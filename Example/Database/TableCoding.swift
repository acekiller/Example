//
//  TableCoding.swift
//  Example
//
//  Created by Mars Scala on 2020/11/13.
//

import Foundation
import SQLite

public protocol TableCoding {
    static func createSQL() -> String
}
