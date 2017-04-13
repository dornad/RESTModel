//
//  ModelResource.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 4/14/17.
//  Copyright © 2017 REST Models. All rights reserved.
//

import Foundation
@testable import Chillax

struct ModelResource: RESTResource {

    func path(for operation: RESTOperation) -> URLComponents {
        return path(for: operation, withIdentifier: nil)
    }

    func path(for operation: RESTOperation, withIdentifier identifier: AnyHashable? = nil) -> URLComponents {

        var components: URLComponents = URLComponents()
        components.scheme = "http"
        components.port = 8080
        components.host = "localhost"
        components.path = "/books"
        return components
    }
}
