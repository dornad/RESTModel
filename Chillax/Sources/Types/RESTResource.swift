//
//  RESTResource.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 12/25/16.
//  Copyright © 2016 Paperless Post. All rights reserved.
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
    
    /// A structure containing configuration values.  These configuration values can be global or 
    /// local to the current `RESTResource`.
    var configuration: Configuration { get set }
    
    /// A closure that provides a `Data` representataion of the HTTP body of an outgoing request.
    var httpBodyProvider: (JSONDictionary) throws -> Data { get }
    
    /// A URLComponents instance
    ///
    /// Recommended that it contains values for scheme, port, host and path
    var rootURLComponents: URLComponents { get }

    /// Parse data from the backend into a JSON Dictionary.
    ///
    /// - Parameter data: Data from the backend
    /// - Returns: A `JSON`, either a Dictionary or Array of Dictionaries
    func parse(data: Data) -> JSON
    
}
