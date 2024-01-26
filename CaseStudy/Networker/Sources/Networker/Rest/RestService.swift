//
//  File.swift
//  
//
//  Created by Koray Yıldız on 16.09.22.
//

import Foundation

public enum APIError: Error {
    case generic
    case emptyData
    case decoding
    case executable
    case api(String)

    public var message: String {
        return "Hoopss Something went wrong"
    }
}

public class RestService: Service {

    public typealias Backend = RestAPI
    private let backend: RestAPI

    private var operations = [String: URLSessionDataTask]()
    private let completionQueue: DispatchQueue

    required public init(backend: RestAPI) {
        self.backend = backend
        self.completionQueue = .main
    }

    public func execute<T>(operation: RestAPI.Operation,
                           type: T.Type,
                           completion: @escaping Callback<NetworkResult<T>>) where T : Decodable {
        let dataTaskCompletion: DataTaskCompletion = { [weak self] data, _, error in
            guard error == nil else {
                self?.completionQueue.async {
                    completion(.failure(APIError.generic))
                }
                return
            }

            guard let data = data else {
                self?.completionQueue.async {
                    completion(.failure(APIError.emptyData))
                }
                return
            }

            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                self?.completionQueue.async {
                    completion(.success(object))
                }
            }
            catch let error {
                debugPrint(error)
                self?.completionQueue.async {
                    completion(.failure(APIError.decoding))
                }
            }

        }

        do {
            let executable = try backend.executable(task: operation, completion: dataTaskCompletion)
            operations[String(describing: T.self)] = executable
            executable.resume()
        }
        catch {
            completionQueue.async {
                completion(.failure(APIError.executable))
            }
        }
    }

    public func execute<T>(operation: RestAPI.Operation, type: T.Type) async throws -> T where T : Decodable {
        do {
            let (data, response) = try await backend.execute(task: operation)
            if let httpResponse = response as? HTTPURLResponse {
                if 400 == httpResponse.statusCode {
                    let error = try? JSONDecoder().decode(NetworkError.self, from: data)
                    if let error {
                        throw APIError.api(error.title)
                    }
                }
            }
            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                return object
            }
            catch {
                throw APIError.decoding
            }
        }
        catch {
            throw APIError.generic
        }
    }

    deinit {
        operations.values.forEach {
            $0.cancel()
        }
    }
}

struct NetworkError: Decodable {
    let title: String
}
