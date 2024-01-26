//
//  File.swift
//  
//
//  Created by Koray Yıldız on 16.09.22.
//

import Foundation

public typealias Callback<T> = (_: T) -> Void
public typealias NetworkResult<T> = Result<T, APIError>
public typealias DataTaskCompletion = (Data?, URLResponse?, Error?) -> Void
