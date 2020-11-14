//
//  Util.swift
//  Example
//
//  Created by Mars Scala on 2020/11/14.
//

import Foundation

private let dbName = "data"

private func registerDefaultTables(dataStore: DataStore) {
    _ = try? dataStore.create(table: KeyValue.createSQL)
    _ = try? dataStore.create(table: RequestHistory.createSQL)
}

func registerTable(create sql: () -> String) {
    _ = try? dataStore?.create(table: sql)
}

let dataStore: DataStore? = {
    var dataDirectoryURL = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("database")
    if !FileManager.default.fileExists(atPath: dataDirectoryURL.path) {
        try? FileManager.default.createDirectory(at: dataDirectoryURL,
                                                 withIntermediateDirectories: true,
                                                 attributes: nil)
    }
    let dataStore = try? DataStore(url: dataDirectoryURL.appendingPathComponent("\(dbName).db"))
    guard let store = dataStore else {
        return nil
    }
    registerDefaultTables(dataStore: store)
    return store
}()

private var endPointSubscribers = [String: (Data) -> Void]()

func subscribeEndPointData(subscriber:@escaping (Data) -> Void) -> String {
    let uniqueID = UUID().uuidString
    endPointSubscribers[uniqueID] = subscriber
    return uniqueID
}

func removeSubscriber(uniqueID: String) {
    endPointSubscribers.removeValue(forKey: uniqueID)
}

func updateEndPointData(data: Data) {
    let subscribers = endPointSubscribers
    subscribers.forEach { (_, value) in
        value(data)
    }
}

let defaultNetwork: Network = {
    let net = Network.default
    net.willRequest = {
        let value = RequestHistory.encode(key: Date().description,
                                          value: $0.url?.absoluteString ?? "")
        var requestInfo = $0.url?.absoluteString ?? ""
        requestInfo.append(" params [\n")
        $0.allHTTPHeaderFields?.forEach {
            requestInfo.append("\($0): \($1)\n")
        }
        requestInfo.append("]")
        print("will save : \(requestInfo)")
        _ = try? dataStore?.insert(value, into: RequestHistory.table)
    }
    return net
}()
