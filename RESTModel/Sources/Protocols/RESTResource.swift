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
    /// - Returns: A `JSON`, either a Dictionary or Array of Dictionaries
    func parse(data: Data) -> JSON?
}

