//
//  RouteRepresentable.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 12/25/16.
//  Copyright © 2016 Paperless Post. All rights reserved.
//

import Foundation

/// A type that can be represented by a REST-ful Resource
public protocol ResourceRepresentable {
    
    /// Holds information about how to convert a `ResourceRepresentable` into its RESTful resource.
    static var resourceInformation: ResourceRepresentableConfiguration { get }

    /// An unique identifier for the model.
    ///
    /// This would correspond to the identifier of a resource in a REST api, for example, for `GET https://test.myapi.org/someResourceName/1`, the identifier would be `1`
    var identifier: AnyHashable { get }
    
    /// Provides the JSON representation of the `ResourceRepresentable` that is required in a specific REST Operation
    /// - Parameter operation: The REST operation that is being requested.
    /// - Returns: A Data of the JSON that corresponds to the `ChillaxOperation`.
    /// - Throws: An encoding error.
    func jsonRepresentation(for operation: ChillaxOperation) throws -> Data
}
