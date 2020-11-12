//
//  Network.swift
//  Example
//
//  Created by Mars Scala on 2020/11/12.
//

import Foundation

final public class Network {
    private let session: URLSession
    private let baseURL: URL?
    private let timeoutInterval: TimeInterval
    private var tasks = [URLSessionTask]()
    private var successStatuscodes = Set<Int>([200, 201])
    static let `default` = Network(timeoutInterval: 10, baseURL: URL(string: "https://api.github.com"))

    init(timeoutInterval: TimeInterval, baseURL: URL?) {
        self.baseURL = baseURL
        self.timeoutInterval = timeoutInterval
        self.session = URLSession(configuration: URLSessionConfiguration.default)
    }

    func get<T>(_ relativePath: String,
                parameter: [String: String] = [:],
                serialization:@escaping (Data) -> T,
                success: @escaping (T, HTTPURLResponse) -> Void,
                failed: @escaping (URLResponse?, Error?) -> Void) {
        request(method: .GET,
                relativePath: relativePath,
                parameter: parameter,
                serialization: serialization,
                success: success,
                failed: failed)
    }

    private func request<T>(method: HTTPMethod,
                            relativePath: String,
                            parameter: [String: String],
                            serialization:@escaping (Data) -> T,
                            success: @escaping (T, HTTPURLResponse) -> Void,
                            failed: @escaping (URLResponse?, Error?) -> Void) {
        guard let request = formatRequst(method: method,
                                         relativePath: relativePath,
                                         parameter: parameter) else {
            failed(nil, "生成URLRequest失败")
            return
        }
        let task = session.dataTask(with: request) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.assignResponseData(result: ($0, $1, $2),
                                          serialization: serialization,
                                          success: success,
                                          failed: failed)
        }
        tasks.append(task)
        task.resume()
    }

    func assignResponseData<T>(result: (Data?, URLResponse?, Error?),
                               serialization:@escaping (Data) -> T,
                               success: @escaping (T, HTTPURLResponse) -> Void,
                               failed: @escaping (URLResponse?, Error?) -> Void) {
        defer {
            tasks.removeAll { task in
                return task.response == result.1
            }
        }

        if nil != result.2 {
            failed(result.1, result.2)
            return
        }

        guard let resp = result.1 as? HTTPURLResponse, successStatuscodes.contains(resp.statusCode) else {
            failed(result.1, result.2)
            return
        }

        let result = serialization(result.0 ?? Data())
        success(result, resp)
    }

    func formatRequst(method: HTTPMethod, relativePath: String, parameter: [String: String]) -> URLRequest? {
        guard let url = API.relative(relativePath).url(baseURL: baseURL) else {
            return nil
        }

        var request = URLRequest(url: url, cachePolicy: method.cachePolicy(), timeoutInterval: timeoutInterval)
        request.updateRequestParameters(method: method, parameter: parameter)
        return request
    }

    deinit {
        tasks.forEach {$0.cancel()}
    }

}

extension String: Error {
}

extension Network {
    enum HTTPMethod {
        case GET, POST, PUT, DELETE

        func methodName() -> String {
            switch self {
            case .POST:
                return "POST"
            case .PUT:
                return "PUT"
            case .DELETE:
                return "DELETE"
            default:
                return "GET"
            }
        }

        func cachePolicy() -> URLRequest.CachePolicy {
            switch self {
            case .GET:
                return .returnCacheDataElseLoad
            default:
                return .reloadRevalidatingCacheData
            }
        }
    }
}

extension Network {
    enum API {
        case relative(String)
        func url(baseURL: URL?) -> URL? {
            switch self {
            case let .relative(relativePath):
                return URL(string: relativePath, relativeTo: baseURL)?.absoluteURL
            }
        }
    }
}

extension URLRequest {
    mutating func updateRequestParameters(method: Network.HTTPMethod, parameter: [String: String]) {
        httpMethod = method.methodName()
        switch method {
        case .GET:
            updateGetParameters(parameter: parameter)
        default:
            //TODO:
            break
        }
    }

    private mutating func updateGetParameters(parameter: [String: String]) {
        parameter.forEach { (key: String, value: String) in
            self.addValue(value, forHTTPHeaderField: key)
        }
    }
}
