//
//  RestAPI.swift
//  
//
//  Created by Koray Yıldız on 16.09.22.
//

import Foundation


public final class RestAPI: API {

    public typealias Operation = HTTPTask

    public typealias Executable = URLSessionDataTask

    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func executable(task: Operation, completion: @escaping DataTaskCompletion) throws -> URLSessionDataTask {
        return try session.dataTask(with: task.asURLRequest(), completionHandler: completion)
    }

    public func execute(task: Operation) async throws -> (Data, URLResponse) {
        return try await session.data(for: task.asURLRequest())
    }
}
