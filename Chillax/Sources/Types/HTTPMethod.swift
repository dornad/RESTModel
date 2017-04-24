//
//  HTTPMethod.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 4/28/17.
//  Copyright © 2017 REST Models. All rights reserved.
//

import Foundation

/// An Swift enumeration providing a type-safe enumeration for the HTTP Method
public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}
