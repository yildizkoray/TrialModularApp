//
//  API.swift
//  
//
//  Created by Koray Yıldız on 16.09.22.
//

import Foundation

public protocol API {
    associatedtype Operation
    associatedtype Executable

    func executable(task: Operation, completion: @escaping DataTaskCompletion) throws -> Executable
    func execute(task: Operation) async throws -> (Data, URLResponse)
}
