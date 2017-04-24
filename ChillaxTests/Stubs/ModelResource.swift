//
//  ModelResource.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 4/14/17.
//  Copyright © 2017 Paperless Post. All rights reserved.
//

import Foundation
@testable import Chillax

struct ModelResource: RESTResource {
    
    var configuration: Configuration = ResourceConfiguration()
    
    var httpBodyProvider: (JSONDictionary) throws -> Data = { dict -> Data in
        
        return try JSONSerialization.data(withJSONObject: dict, options: [])
    }
    
    var rootURLComponents: URLComponents {
        
        var components: URLComponents = URLComponents()
        components.scheme = "http"
        components.port = 8080
        components.host = "localhost"
        components.path = "/books"
        return components
    }
}
