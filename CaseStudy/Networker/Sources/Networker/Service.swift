//
//  File.swift
//  
//
//  Created by Koray Yıldız on 16.09.22.
//

import Foundation

public protocol Service {
    associatedtype Backend: API

    init(backend: Backend)

    func execute<T: Decodable>(operation: Backend.Operation, type: T.Type, completion: @escaping Callback<NetworkResult<T>>)
    func execute<T: Decodable>(operation: Backend.Operation, type: T.Type) async throws -> T
}
