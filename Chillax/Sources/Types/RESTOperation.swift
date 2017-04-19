//
//  RESTOperation.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 4/13/17.
//  Copyright © 2017 Paperless Post. All rights reserved.
//

import Foundation

/// The REST Operations available in the framework
///
/// ### Recommended HTTP Verb Mapping
///
/// - `GET` : `RESTOperation.getAll`, `RESTOperation.get`
/// - `POST` : `RESTOperation.create`
/// - `PUT` : `RESTOperation.update`
/// - `DELETE` : `RESTOperation.delete`
///
///
/// - retrieve: Retrieves an element.
/// - create: Creates an element
/// - update: Updates an element
/// - delete: Deletes an element
public enum RESTOperation {
    case retrieve (RetrieveType)
    case create, update, delete
}

/// Type of Retrieve operations
///
/// - single: retrieve a single element
/// - many: retrieve several elements
public enum RetrieveType {
    case single, many
}


// MARK: Equatable implementation

extension RESTOperation: Equatable {}

/// Implements == for Equatable
///
/// - Parameters:
///   - lhs: left hand side element
///   - rhs: right hand side element
/// - Returns: true if they're equal, false otherwise
public func ==(lhs: RESTOperation, rhs: RESTOperation) -> Bool {

    switch (lhs, rhs) {

    case (.create, .create):
        return true
    case (.update, .update):
        return true
    case (.delete, .delete):
        return true
    case (.retrieve(let lhsr), .retrieve(let rhsr)):

        switch (lhsr, rhsr) {
        case (.single, .single):
            return true
        case (.many, .many):
            return true
        default:
            return false
        }

    default:

        return false
    }
}
