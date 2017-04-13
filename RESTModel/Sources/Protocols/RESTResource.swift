//
//  RESTResource.swift
//  RESTModel
//
//  Created by Daniel Rodriguez on 12/25/16.
//  Copyright © 2016 REST Models. All rights reserved.
//

import Foundation

/// Holds information about how to convert a `ResourceRepresentable` into its RESTful resource.
///
///
/// ### Implementation Tips
///
/// A class or struct that conforms to this protocol could be implemented with only one method:
///
/// ```
/// public func path(for operation:RESTOperation, withIdentifier identifier:Int? = nil) {
///   // your implementation goes here
/// }
/// ```
public protocol RESTResource {

    associatedtype Result

    /// Returns the fully qualified `"path"` that matches a REST Operation on a specific Resource.
    ///
    /// For example, given
    ///
    ///     `GET https://test.myapi.org/someResourceNamePlural/1`
    ///
    /// the operation would be `RESTOperation.get`, the identifier would be
    /// `1` and the fully qualified path returned by this method would be
    ///
    ///     `https://test.myapi.org/someResourceNamePlural/1`
    ///
    /// - Parameters:
    ///   - operation: The REST operation that is being requested.
    ///   - identifier: An unique identifier for the resource.  See `identifier:Int` in `ResourceRepresentable`.
    /// - Returns: The `"path"` that matches the REST Operation
    ///
    func path(for operation: RESTOperation, withIdentifier identifier: AnyHashable?) -> Result


    /// Parse data from the backend into a JSON Dictionary.
    ///
    /// - Parameter data: Data from the backend
    /// - Returns: A `JSONValue`, either a Dictionary or Array of Dictionaries
    func parse(data: Data) -> JSON?
}

/// The REST Operations available in the framework
///
/// ### Recommended HTTP Verb Mapping
///
/// - `GET` : `RESTOperation.getAll`, `RESTOperation.get`
/// - `POST` : `RESTOperation.create`
/// - `PUT` : `RESTOperation.update`
/// - `DELETE` : `RESTOperation.delete`
///
///
/// - retrieve: Retrieves an element.
/// - create: Creates an element
/// - update: Updates an element
/// - delete: Deletes an element
public enum RESTOperation {
    case retrieve (RetrieveType)
    case create, update, delete
}

/// Type of Retrieve operations
///
/// - single: retrieve a single element
/// - many: retrieve several elements
public enum RetrieveType {
    case single, many
}

extension RESTOperation: Equatable {}

public func ==(lhs: RESTOperation, rhs: RESTOperation) -> Bool {

    switch (lhs, rhs) {

    case (.create, .create):
        return true
    case (.update, .update):
        return true
    case (.delete, .delete):
        return true
    case (.retrieve(let lhsr), .retrieve(let rhsr)):

        switch (lhsr, rhsr) {
        case (.single, .single):
            return true
        case (.many, .many):
            return true
        default:
            return false
        }

    default:

        return false
    }
}
