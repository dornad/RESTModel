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
    case success ([T])
    case error (Error)
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
    func perform(operation: RESTOperation, input: T, callback: @escaping (Result<T>) -> Void)

    /// Perform a network operation on an element's type.  i.e.: retrieve all elements.
    ///
    /// - Parameters:
    ///   - operation: create, retrieve, update or delete
    ///   - callback: callback result
    func perform(operation: RESTOperation, callback: @escaping (Result<T>) -> Void)
}
