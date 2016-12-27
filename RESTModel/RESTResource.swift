//
//  RESTResource.swift
//  RESTModel
//
//  Created by Daniel Rodriguez on 12/25/16.
//  Copyright © 2016 REST Models. All rights reserved.
//

import Foundation

public protocol RESTResource {

    func path(forOperation operation: RESTOperation, value: Int?) -> String

    func path(forOperation operation: RESTOperation) -> String
}

public enum RESTOperation {
    case getAll, get, create, update, delete
}
