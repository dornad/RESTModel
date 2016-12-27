//
//  RouteRepresentable.swift
//  RESTModel
//
//  Created by Daniel Rodriguez on 12/25/16.
//  Copyright © 2016 REST Models. All rights reserved.
//

import Foundation

/// A type that can be represented by a REST-ful Resource
public protocol ResourceRepresentable {

    /// The Resource holding information about how to convert this model into its RESTful resource.
    static var resourceInformation: RESTResource { get }

    /// A type that takes care of REST operations for this type.
    static var manager: NetworkManager<Self> { get }

    /// Initializes with a JSON Resource.
    init?(data:JSON)
}
