//
//  Model.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 4/14/17.
//  Copyright © 2017 Paperless Post. All rights reserved.
//

import Foundation
@testable import Chillax

struct Model: ResourceRepresentable {

    enum ModelError : Error {
        case invalidJSON
    }

    /// Provides the JSON representation of the `ResourceRepresentable` that is required in a specific REST Operation
    /// - Parameter operation: The REST operation that is being requested.
    /// - Returns: A JSON value.
    func jsonRepresentation(for operation: RESTOperation) -> JSONDictionary {
        return ["id" : identifier]
    }

    /// An unique identifier for the model.
    ///
    /// This would correspond to the identifier of a resource in a REST api, for example, for `GET https://test.myapi.org/someResourceName/1`, the identifier would be `1`
    var identifier: AnyHashable

    static var service = AnyNetworkService<Model>()

    static var resourceInformation: RESTResource = ModelResource()
}



extension Model {

    init(data dictionary: JSONDictionary) throws {

        guard let id = dictionary["id"] as? AnyHashable else { throw ModelError.invalidJSON }

        self.identifier = id
    }
}
