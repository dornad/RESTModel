//
//  ModelResource.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 4/14/17.
//  Copyright © 2017 Paperless Post. All rights reserved.
//

import Foundation
@testable import Chillax

struct ModelResource: ResourceRepresentableConfiguration {
    
    var configuration: Configuration = ResourceConfiguration()
    
    var rootURLComponents: URLComponents {
        var components: URLComponents = URLComponents()
        components.scheme = "http"
        components.port = 8080
        components.host = "localhost"
        components.path = "/books"
        return components
    }
}
