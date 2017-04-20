//
//  RESTResource+Request.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 4/13/17.
//  Copyright © 2017 Paperless Post. All rights reserved.
//

import Foundation

extension RESTResource {
    
    internal func request(for operation: RESTOperation) throws -> URLRequest {
        return try _request(for: operation)
    }

    internal func request <T: ResourceRepresentable> (for operation: RESTOperation, fromItem item : T?) throws -> URLRequest {
        let itemIdentifier = item?.identifier
        let json = item?.jsonRepresentation(for: operation)
        return try _request(for: operation, itemIdentifier: itemIdentifier, json: json)
    }

    private func _request(for operation: RESTOperation, itemIdentifier identifier: AnyHashable? = nil, json: JSONDictionary? = nil) throws -> URLRequest {

        guard let url = path(for: operation, withIdentifier: identifier).url else {
            throw RequestBuilderError.urlIsNil
        }

        var request = URLRequest(url: url)
        request.httpMethod = operation.httpMethod

        switch operation {
        case .retrieve(_):
            break
        case .delete:
            break
        case .create:
            fallthrough
        case .update:
            
            guard let json = json else { throw RequestBuilderError.jsonIsNil }
            
            self.configuration.headerFields.forEach {
                request.addValue($1, forHTTPHeaderField: $0)
            }
            
            guard let httpBody = try? self.httpBodyProvider(json) else { throw RequestBuilderError.httpBodyIsNil }
            request.httpBody = httpBody
        }

        return request
    }

}

private enum RequestBuilderError: Int, Error {    
    case urlIsNil = 0
    case jsonIsNil
    case httpBodyIsNil
}

