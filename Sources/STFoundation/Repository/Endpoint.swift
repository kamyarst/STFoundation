//
//  Endpoint.swift
//
//
//  Created by Kamyar Sehati on 06/08/2023.
//

import Foundation

// MARK: - Endpoint

public protocol Endpoint {
    var scheme: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
    var body: Data? { get }

    func request(host: String) -> URLRequest
}

extension Endpoint {

    public func request(host: String) -> URLRequest {
        let url = self.convertToURL(host: host)
        var request = URLRequest(url: url)
        request.httpMethod = self.method.name
        request.allHTTPHeaderFields = self.headers
        request.httpBody = self.body

        return request
    }

    private func convertToURL(host: String) -> URL {
        var components = URLComponents()
        components.scheme = self.scheme
        components.host = host
        components.path = self.path
        components.queryItems = self.queryItems

        return components.url!
    }
}

// MARK: - HTTPMethod

public enum HTTPMethod {
    case post
    case get
    case delete

    var name: String {
        String(describing: self).uppercased()
    }
}
