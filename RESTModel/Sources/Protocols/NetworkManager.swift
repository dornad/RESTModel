//
//  NetworkManager.swift
//  RESTModel
//
//  Created by Daniel Rodriguez on 1/12/17.
//  Copyright © 2017 REST Models. All rights reserved.
//

import Foundation


/// An enumeration representing the Result of an operation with the Network Manager.
///
/// - success: The operation completed sucessfully.
/// - error: The operation failed, or completed withj an error.
public enum Result<T: ResourceRepresentable> {
    case success (T)
    case error (Error)
}

/// Performs networking operations for a `ResourceRepresentable`.
public protocol NetworkManager {

    /// The `ResourceRepresentable` associated to this class.
    associatedtype T: ResourceRepresentable

    func delete(item:T, callback: @escaping (Result<T>) -> Void)

    func update(item:T, callback: @escaping (Result<T>) -> Void)

    func create(item: T, callback: @escaping (Result<T>) -> Void)

    func retrieve(identifier: Int, callback: @escaping (Result<T>)-> Void)

    func retrieve(callback: @escaping ([T], Error?) -> Void)
}
