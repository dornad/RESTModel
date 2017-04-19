//
//  RouteRepresentable.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 12/25/16.
//  Copyright © 2016 REST Models. All rights reserved.
//

import Foundation

/// A type that can be represented by a REST-ful Resource
public protocol ResourceRepresentable {

    /// Holds information about how to convert a `ResourceRepresentable` into its RESTful resource.
    static var resourceInformation: RESTResource { get }

    /// A type-erased manager that takes care of networking operations on behalf of the model.
    static var service: AnyNetworkService<Self> { get }

    /// An unique identifier for the model.
    ///
    /// This would correspond to the identifier of a resource in a REST api, for example, for `GET https://test.myapi.org/someResourceName/1`, the identifier would be `1`
    var identifier: AnyHashable { get }

    /// Initializes your model from a JSON.
    ///
    /// - Parameter data: the JSON data.
    /// - Throws: an error thrown when the Model cannot be initialized from the JSON data.
    init(data: JSONDictionary) throws

    /// Provides the JSON representation of the `ResourceRepresentable` that is required in a specific REST Operation
    /// - Parameter operation: The REST operation that is being requested.
    /// - Returns: A JSON value.
    func jsonRepresentation(for operation: RESTOperation) -> JSONDictionary
}
