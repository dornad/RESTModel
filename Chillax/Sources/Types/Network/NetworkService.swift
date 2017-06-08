//
//  NetworkService.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 1/12/17.
//  Copyright © 2017 Paperless Post. All rights reserved.
//

import Foundation


/// An enumeration representing the Result of an operation with the Network Manager.
///
/// - success: The operation completed sucessfully.
/// - error: The operation failed, or completed withj an error.
public enum Result<T: ResourceRepresentable> {
    case success ([T])
    case error (Error)
}

/// A protocol for a Swift.Operation type.
public protocol NetworkServiceOperation {
    
    /// Start the operation
    func start()
    
    /// End the operation
    mutating func cancel()
}

/// Performs networking operations for a `ResourceRepresentable`.
public protocol NetworkService {

    /// The `ResourceRepresentable` associated to this class.
    associatedtype T: ResourceRepresentable

    /// Perform a network operation on an element.
    ///
    /// - Parameters:
    ///   - operation: create, retrieve, update or delete
    ///   - input: the input element
    ///   - callback: callback result
    func perform(operation: ChillaxOperation, callback: @escaping (Result<T>) -> Void) -> NetworkServiceOperation
}
