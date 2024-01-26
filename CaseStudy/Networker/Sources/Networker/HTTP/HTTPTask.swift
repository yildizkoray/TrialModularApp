//
//  File.swift
//  
//
//  Created by Koray Yıldız on 16.09.22.
//

import Foundation

private struct Constants {
    struct Privates {
        static let host = "raw.githubusercontent.com"
    }
}

enum URLCreatingError: Error {
    case invalidURL
}

public protocol HTTPTask {
    var method: HTTPMethod { get }
    var host: String { get }
    var path: String { get }

    func asURL() throws -> URL
    func asURLRequest() throws -> URLRequest
}

public extension HTTPTask {

    var host: String {
        return Constants.Privates.host
    }

    func asURL() throws -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path

        guard let url = urlComponents.url else {
            throw URLCreatingError.invalidURL
        }
        return url
    }

    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: try asURL())
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}
